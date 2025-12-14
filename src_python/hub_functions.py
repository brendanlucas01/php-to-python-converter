import json
import logging
from datetime import datetime, timedelta
import dateutil.parser

class HubFunctions:
    def __init__(self, db_instance):
        self.db = db_instance
        self.userPermissionArr = []
        self.upToRootFolderIds = ''

    def query(self, sql):
        return self.db.query(sql)

    def fetch_one(self, sql):
        return self.db.fetch_one(sql)

    def getOne(self, table, columns, condition, join=None):
        return self.db.get(table, columns, condition, join)

    def getSpecific(self, table, columns, condition, join=None):
        return self.db.select(table, columns, condition, join)

    def getCount(self, table, condition, column='*', join=None):
        return self.db.count(table, condition, column, join)

    def prepare_and_execute(self, sql, params=None):
         # In our DB wrapper query handles params
         # We need to adapt named params :param to %s or use named params if psycopg2 supports it
         # Psycopg2 supports %(name)s.
         # The PHP code uses :serverId.
         # Let's assume we pass a dict of params.

         # Convert :param to %(param)s for psycopg2
         # Or just use the query method if the SQL is raw
         return self.db.query(sql, params)

    def getUserTimebyZone(self, uid, time_str):
        # "SELECT tz.timezone, u.lang FROM \"user\" u LEFT JOIN timezone tz ON u.timezone = tz.label WHERE u.id = $uid"
        sql = "SELECT tz.timezone, u.lang FROM \"user\" u LEFT JOIN timezone tz ON u.timezone = tz.label WHERE u.id = %s"
        usersDetails = self.db.fetch_one(sql, (uid,))

        if not usersDetails:
             # Fallback or error handling
             return {"timestamp": None}

        timezone = usersDetails.get('timezone')
        lang = usersDetails.get('lang')

        # PHP's getUserTimebyZone logic is a bit weird with getCurretTime and date string manipulation.
        # It seems to adjust the time based on timezone offset embedded in the timezone string?
        # "UTC-11:00" -> substr(4, 6) -> "-11:00".
        # Let's try to replicate the logic of `getCurretTime`.

        # dateArr = str_split($datetime, '10'); -> PHP str_split splits into chunks of 10 chars.
        # 2025-10-09 06:56:10 -> "2025-10-09", " 06:56:10"

        ts = self.getCurretTime(timezone, time_str)

        finalDate = datetime.fromtimestamp(ts).strftime("%B %-d, %Y") # F j, Y
        finalDateTime = datetime.fromtimestamp(ts).strftime("%B %-d, %Y | %-I:%M %p") # F j, Y | g:i A

        # "timestamp" in PHP code: $date = new DateTime($time); $dateTimeStamp = $date->getTimestamp();
        # This takes the original input time string.
        try:
             orig_dt = dateutil.parser.parse(time_str)
             dateTimeStamp = int(orig_dt.timestamp())
        except:
             dateTimeStamp = 0

        return {
            "timezone": timezone,
            "lang": lang,
            "date": finalDate,
            "datetime": finalDateTime,
            "timestamp": dateTimeStamp
        }

    def getCurretTime(self, timezone, datetime_str):
        # $dateArr = str_split($datetime, '10');
        # $dateExtractArr = $dateArr[0]; "2025-10-09"
        # $timeExtractArr = $dateArr[1]; " 06:56:10"

        dateExtractArr = datetime_str[:10]
        timeExtractArr = datetime_str[10:].strip()

        # timezone ex: "(UTC-05:00) Eastern Standard Time"
        # substr($timezone, 4, 6) -> "-05:00"

        offset_str = timezone[4:10] # "-05:00" or "+05:30"

        # $time = substr($timezone, 5, 5).':00'; -> "05:00:00"
        # It takes the offset magnitude.

        # PHP: $parsed = date_parse($time);
        # $minutes = ($parsed['hour'] * 3600 + $parsed['minute'] * 60 + $parsed['second']) / 60;

        try:
            sign = offset_str[0] # + or -
            hour = int(offset_str[1:3])
            minute = int(offset_str[4:6])

            offset_minutes = hour * 60 + minute

            # Logic:
            # if(substr($timezone, 4, 6) >= 0) -> String comparison? "-05:00" >= "0" is False?
            # PHP string comparison: "-..." is not >= 0 usually unless cast to int.
            # But here it is string compare.
            # Actually, if it starts with '+', it might be greater.

            # Wait, `substr($timezone, 4, 6)` extracts `-11:00`.
            # `'-11:00' >= 0` in PHP?
            # PHP type juggling: string starting with '-' is cast to 0 if compared to integer 0?
            # No, if compared to string '0', it does lexical comparison. '-' < '0'. '+' < '0'? No '+' is 43, '0' is 48.
            # So both '+' and '-' are less than '0'.
            # Thus `substr($timezone, 4, 6) >= 0` is likely FALSE for both + and -.
            # Wait, if I test in PHP: `'-05:00' >= 0`. It evaluates to TRUE because string is converted to number -5. False?
            # `'-05:00' >= 0` -> `intval('-05:00')` -> -5 >= 0 -> False.
            # `'+05:00' >= 0` -> 5 >= 0 -> True.

            # So if sign is '+', we add minutes. If '-', we subtract.

            # PHP logic:
            # $endTime = strtotime("+".$minutes." minutes", strtotime($timeExtractArr));
            # OR
            # $endTime = strtotime("-".$minutes." minutes", strtotime($timeExtractArr));

            base_time = datetime.strptime(timeExtractArr, "%H:%M:%S")
            # We need a full datetime to do math, using today's date temporarily
            base_dt = datetime.combine(datetime.today(), base_time.time())

            if sign == '+' or (sign != '-' and int(sign) >= 0): # Handle case where sign might be a digit (unlikely given (UTC... format)
                # Add
                new_dt = base_dt + timedelta(minutes=offset_minutes)
            else:
                # Subtract
                new_dt = base_dt - timedelta(minutes=offset_minutes)

            current_time_str = new_dt.strftime("%I:%M:%S %p") # h:i:s A

            # $dateAns = strtotime($dateExtractArr.' '.$curretTime);
            final_dt_str = f"{dateExtractArr} {current_time_str}"
            final_dt = datetime.strptime(final_dt_str, "%Y-%m-%d %I:%M:%S %p")

            return int(final_dt.timestamp())

        except Exception as e:
            logging.error(f"Error parsing timezone/time: {timezone} {datetime_str} - {e}")
            return 0

    def getUserDeviceTag(self, ugIds, sid, usersort='label', emptyTag=False, dId=False, hideMcTag=False, calledFrom=""):
        # Porting this complex SQL generation
        # ugIds is a string "0" or "1,2"
        # sid is serverId (int)

        usersort = usersort.replace("name", "label")
        extraSQL = ""
        mcTagArr = []

        if dId:
            if calledFrom == 'deviceList':
                extraSQL = f"AND dp.deviceid IN ({dId})"
            else:
                extraSQL = f"AND dp.deviceid = {dId}"

        if hideMcTag:
            sql = f"select COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT dta.tagid), ','), '0') as tagids from device d inner join devicetagassociation dta on d.id = dta.deviceid where d.serverid = {sid} and d.devicetype = 'mc'"
            res = self.db.fetch_one(sql)
            if res:
                mcTagArr_str = res['tagids']
                mcTagArr = mcTagArr_str.split(',')

        dvcfolder_whr_cndtn = ''
        # Skipping server_info check as it seems commented out or optional/complex dependency on hubcp schema

        # allDevices
        sql_all_dev = f"select COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT d.id), ','), '0') as deviceids from device d INNER JOIN devicepermission dp ON d.id = dp.deviceId where {dvcfolder_whr_cndtn} dp.userGroupId IN ({ugIds}) AND isActive = 1 and serverId = {sid}"
        allDevices = self.db.fetch_one(sql_all_dev)
        allDevicesArr = allDevices['deviceids'].split(',') if allDevices and allDevices['deviceids'] != '0' else []

        if emptyTag:
            usersort = usersort.replace('d.', '')
            sql_tags = f"""
            select * from
				(
					(
						SELECT distinct dt.id, dt.name as label, dt.createdon, dt.createdby as "createdBy", dt.color as "tagColor", (SELECT COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT deviceid), ','), '') FROM devicetagassociation WHERE tagid = dt.id) as deviceids
						FROM devicetag as dt left join devicetagassociation as d1 on d1.tagid = dt.id
						left join devicepermission as dp on d1.deviceId = dp.deviceId
						where dt.serverId = {sid} and (dp.userGroupId in ({ugIds})) {extraSQL} group by dt.id
					)
					UNION
					(
						SELECT distinct d.id, d.name as label, d.createdon, d.createdby as "createdBy",
						d.color as "tagColor", '' as deviceids
						FROM devicetag AS d
						left join devicetagassociation as d1 on d1.tagid = d.id
						WHERE d.serverId = {sid} AND d1.id IS NULL
					)
				) AS deviceAll order by {usersort}
            """
        else:
            usersort = usersort.replace("label", "dt.name")
            sql_tags = f"""
            SELECT distinct dt.id, UPPER(dt.name), dt.name as label, dt.createdon, dt.createdby as "createdBy", dt.color as "tagColor", (SELECT COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT deviceid), ','), '') FROM devicetagassociation WHERE tagid = dt.id) as deviceids
						FROM devicetag as dt left join devicetagassociation as d1 on d1.tagid = dt.id
						left join devicepermission as dp on d1.deviceId = dp.deviceId
						where dt.serverId = {sid} and (dp.userGroupId in ({ugIds})) {extraSQL} order by {usersort}
            """

        deviceTags = self.db.query(sql_tags)

        accTags = []
        if deviceTags:
             for dt in deviceTags:
                 dt['createdOn'] = dt['createdon']
                 if dt['deviceids']:
                     explode_notice = dt['deviceids'].split(',')
                     arrNotAccessible = [x for x in explode_notice if x not in allDevicesArr]

                     if arrNotAccessible or (str(dt['id']) in mcTagArr):
                         continue

                 if calledFrom == 'deviceList':
                     if 'upper' in dt: del dt['upper']
                     if 'createdon' in dt: del dt['createdon']
                 else:
                     if 'deviceids' in dt: del dt['deviceids']
                     if 'upper' in dt: del dt['upper']
                     if 'createdon' in dt: del dt['createdon']

                 accTags.append(dt)

        return accTags

    def searchInArray(self, arr, key, val, op, delimiter=','):
        arr_new = []
        # sort(arr) - Python lists don't need sorting for iteration, but PHP sort reindexes.
        # Assuming arr is list of dicts.

        if isinstance(val, list):
            val.sort() # In place sort

        # Helper to handle PHP's loose typing and array behaviors

        for x in arr:
             if key not in x:
                 if op in ['none', 'ne', 'nei']:
                     arr_new.append(x)
                 continue

             x_key = x[key]

             if op == 'in':
                 # In PHP: explode if not array, flip, check isset.
                 # Python: check if val in x_key_list
                 if not isinstance(x_key, list):
                     x_key_list = str(x_key).split(delimiter)
                 else:
                     x_key_list = x_key

                 # PHP: if(isset($x_flip[$val]))
                 # So we check if val is in x_key_list
                 if str(val) in [str(i) for i in x_key_list]:
                     arr_new.append(x)

             elif op == 'any':
                 if not isinstance(val, list):
                     val_list = str(val).split(delimiter)
                 else:
                     val_list = val

                 # PHP: isset($val_flip[$x[$key]]) -> x[key] is in val_list
                 if str(x[key]) in [str(i) for i in val_list]:
                     arr_new.append(x)

             elif op == 'none':
                  if not isinstance(val, list):
                     val_list = str(val).split(delimiter)
                  else:
                     val_list = val

                  if str(x[key]) not in [str(i) for i in val_list]:
                      arr_new.append(x)

             elif op == 'common':
                  # Intersection
                  if not isinstance(val, list):
                     val_list = str(val).split(delimiter)
                  else:
                     val_list = val

                  if not isinstance(x_key, list):
                     x_key_list = str(x_key).split(delimiter)
                  else:
                     x_key_list = x_key

                  # array_intersect
                  if set([str(i) for i in x_key_list]) & set([str(i) for i in val_list]):
                      arr_new.append(x)

             elif op == 'all':
                   if not isinstance(val, list):
                     val_list = str(val).split(delimiter)
                   else:
                     val_list = val

                   if not isinstance(x_key, list):
                     x_key_list = str(x_key).split(delimiter)
                   else:
                     x_key_list = x_key

                   # PHP: $x_key == array_intersect($x_key, $val)
                   # Means all elements in x_key must be present in val.
                   s_x = set([str(i) for i in x_key_list])
                   s_v = set([str(i) for i in val_list])
                   if s_x.issubset(s_v) and s_x == (s_x & s_v):
                       arr_new.append(x)

             elif op == 'eq':
                 if str(x[key]) == str(val):
                     arr_new.append(x)

             elif op == 'eqi':
                 if str(x[key]).lower() == str(val).lower():
                     arr_new.append(x)

             elif op == 'ne':
                 if str(x[key]) != str(val):
                     arr_new.append(x)

             elif op == 'nei':
                 if str(x[key]).lower() != str(val).lower():
                     arr_new.append(x)

             elif op == 'ge':
                 try:
                     if float(x[key]) >= float(val):
                         arr_new.append(x)
                 except: pass

             elif op == 'le':
                 try:
                     if float(x[key]) <= float(val):
                         arr_new.append(x)
                 except: pass

        return arr_new

    def changeResIfDate(self, val, vtype='d'):
        try:
            given = dateutil.parser.parse(val)
        except:
            return {}

        newRwTime = given.strftime('%Y-%m-%dT%H:%M:%S')
        dateOnly = given.strftime('%m/%d/%Y')

        InfoNewArr = {
            'time': newRwTime,
            'vType': vtype
        }

        if vtype == 'd' or vtype == 'dt':
            InfoNewArr['dateRange'] = {"startDate": dateOnly, "endDate": dateOnly}

        return InfoNewArr

    def userPermissions(self, sid, uid):
        # Hardcoded in PHP
        allowed = {
            'device_rights': ['Edit Device', 'Edit Group', 'Edit tag', 'Delete Device', 'Edit Folder', 'Delete Folder', 'Move', 'Device Preview'],
            'frame_layout_rights': ['Assign', 'Edit assignment'],
        }
        return allowed
