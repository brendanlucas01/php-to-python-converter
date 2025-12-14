from fastapi import FastAPI, Request, Response
from fastapi.responses import JSONResponse
from src_python.database import Database
from src_python.hub_functions import HubFunctions
import os
import json
import logging
import math
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)

app = FastAPI()

# Database setup
db = Database()
hub_functions = HubFunctions(db)

# Global variables/Constants from index.php
SERVER_ID = 2
USER_ID = 1
IS_ADMIN = 1
USER_GROUP_DETAILS = [0]
USER_DATA = {
    "userDetails": {
        "serverId": SERVER_ID,
        "userId": USER_ID,
        "isAdmin": IS_ADMIN,
        "userGroupDetails": USER_GROUP_DETAILS
    }
}
BYTES_RATIO = 1024
EPD_LB = 'epd'


@app.get("/")
async def read_root():
    return Response(content="Hello World", media_type="text/html")

@app.get("/hi")
async def read_hi():
    return Response(content="Hi World", media_type="text/html")

@app.get("/devices")
async def get_devices():
    devices = hub_functions.query("SELECT * FROM public.device")
    return JSONResponse(content=devices if devices else [])

@app.get("/devices/briefs/{device_id}")
async def get_device_brief(device_id: str):
    # Validation: PHP uses regex ID_or_CommaID '/^(\d(\,\d)*)+$/'
    # We'll just assume it's valid for now or do simple check
    if not device_id.replace(',', '').isdigit():
         return JSONResponse(content={"code": 1000, "status": "error", "desc": "invalid id"})

    # query
    # Using IN clause to be safer against comma separated list even though fetch_one returns one.
    # Also safe against single ID.
    sql = f"""select d.id, d.name, d.hardwareid as eip, COALESCE(NULLIF(d.watcherVersion, ''), null) AS watcher, u.fname || ' ' || u.lname AS "createdBy", d.autoUpdate as update, COALESCE(d.offlineReboot, 0) as "offlineReboot", thumbversion AS tv, ds.screenshotcapture as ss, COALESCE(NULLIF(slideversion, ''), null) AS slide, d.publicip as "publicIP", d.localip as "localIP", resolution as res, computername AS "cName", d.guid, os, client, ds.desktoprefreshrate AS "refreshRate", ds.desktopcolordepth AS "colorDepth", d.timezone, d.isticket AS "isTicket", d.info, COALESCE(d.createdon, null) as "createdOn"
		from device as d
		left join devicesetting ds on d.id = ds.deviceid
		left join "user" as u on d.createdBy = u.id
		where d.isActive = 1 and d.serverId = {SERVER_ID} and d.id IN ({device_id})"""

    device = hub_functions.fetch_one(sql)

    if device:
        # Date handling
        if device['createdOn']:
            dates = hub_functions.getUserTimebyZone(USER_ID, str(device["createdOn"]))
            device['createdOn'] = dates["timestamp"]

        # Adapters
        device['adapters'] = hub_functions.getSpecific("deviceextraips", ["hardwareid", "description"], {"deviceid": device_id}) # medoo select returns list

        # Timezone label
        device['timezone'] = {'label': device['timezone']}

        userGroupDetails_str = ",".join(map(str, USER_GROUP_DETAILS))

        # Schedules count
        schedules = None
        inactive_schedules = None
        tagCount = None

        current_time_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        if IS_ADMIN:
            schedules = hub_functions.fetch_one(f"SELECT COALESCE( ARRAY_TO_STRING( ARRAY_AGG( s.id ), ','), '0') as scheduleids FROM scheduledeviceassociation left join schedule s on s.id = scheduledeviceassociation.scheduleId WHERE (scheduledeviceassociation.deviceId = {device_id}) AND s.isApproved = 1 and s.isActive = 1 AND s.endDate >= '{current_time_str}' AND s.isCompleted = 1 AND s.startDate IS NOT NULL")

            inactive_schedules = hub_functions.fetch_one(f"SELECT COALESCE( ARRAY_TO_STRING( ARRAY_AGG( s.id ), ','), '0') as scheduleids FROM scheduledeviceassociation left join schedule s on s.id = scheduledeviceassociation.scheduleId WHERE (scheduledeviceassociation.deviceId = {device_id}) AND s.isApproved = 1 and s.isActive = 0 AND s.endDate >= '{current_time_str}' AND s.isCompleted = 1 AND s.startDate IS NOT NULL")

            tagCount = hub_functions.fetch_one(f"SELECT count(DISTINCT d.tagid) as \"tagCount\" FROM devicetagassociation as d WHERE d.deviceId = {device_id}")
        else:
             # Logic for non-admin omitted for brevity/simplicity as default user is admin in PHP
             pass

        device['tag'] = tagCount['tagCount'] if tagCount else 0

        scheduleIdsArr = []
        if schedules and schedules['scheduleids'] != '0':
            scheduleIdsArr = list(set([x for x in schedules['scheduleids'].split(',') if x]))

        inactive_scheduleIdsArr = []
        if inactive_schedules and inactive_schedules['scheduleids'] != '0':
            inactive_scheduleIdsArr = list(set([x for x in inactive_schedules['scheduleids'].split(',') if x]))

        device['schedule'] = {'a': len(scheduleIdsArr), 'i': len(inactive_scheduleIdsArr)}

        contents = False
        if scheduleIdsArr:
            s_ids = ",".join(scheduleIdsArr)
            contentCondition = f" AND schedule.id IN ({s_ids}) "

            if IS_ADMIN:
                sql_c = f"""SELECT COALESCE(COUNT(schedulecontentassociation.contentId), 0) as count FROM schedule
					LEFT JOIN schedulecontentassociation ON schedule.id = schedulecontentassociation.scheduleId
					LEFT JOIN contentLibrary ON contentLibrary.id = schedulecontentassociation.contentId
					WHERE contentLibrary.status = 0 {contentCondition} AND contentLibrary.isApproved = 1"""
                contents = hub_functions.fetch_one(sql_c)

        inactive_contents = False
        if inactive_scheduleIdsArr:
            s_ids_i = ",".join(inactive_scheduleIdsArr)
            inactive_contentCondition = f" AND schedule.id IN ({s_ids_i}) "

            if IS_ADMIN:
                 sql_ci = f"""SELECT COALESCE(COUNT(schedulecontentassociation.contentId), 0) as count FROM schedule
					LEFT JOIN schedulecontentassociation ON schedule.id = schedulecontentassociation.scheduleId
					LEFT JOIN contentLibrary ON contentLibrary.id = schedulecontentassociation.contentId
					WHERE schedule.isActive = 0 AND contentLibrary.status = 0 {inactive_contentCondition} AND contentLibrary.isApproved = 1 AND contentLibrary.serverId = {SERVER_ID}"""
                 inactive_contents = hub_functions.fetch_one(sql_ci)

        device['content'] = {'a': contents['count'] if contents else 0, 'i': inactive_contents['count'] if inactive_contents else 0}

        device['eip'] = '' # Encrypt/Decrypt skipped

        if device['os'] == 4:
            device['watcher'] = None

        device['osv'] = None
        if device['info']:
            try:
                infoArr = json.loads(device['info'])
                if infoArr:
                    if device['os'] == 2:
                        # WebOS logic
                        webos = hub_functions.searchInArray(infoArr, 'label', 'WebOS', 'eqi')
                        webos = hub_functions.searchInArray(webos, 'isEditable', False, 'eq')
                        webos = hub_functions.searchInArray(webos, 'vType', 't', 'eqi')
                        if webos and 'value' in webos[0]:
                             device['osv'] = webos[0]['value']
                    elif device['os'] == 3:
                         # Tizen logic
                        tizenV = hub_functions.searchInArray(infoArr, 'label', 'Tizen', 'eqi')
                        tizenV = hub_functions.searchInArray(tizenV, 'isEditable', False, 'eq')
                        tizenV = hub_functions.searchInArray(tizenV, 'vType', 't', 'eqi')
                        if tizenV and 'value' in tizenV[0]:
                             device['osv'] = tizenV[0]['value']

                    diskDataArr = ['disktotal', 'diskused']
                    memDataArr = ['memorytotal', 'memoryused']

                    device['dsk'] = {'t': None, 'u': None}
                    device['mem'] = {'t': None, 'u': None}

                    for tInfoLp in infoArr:
                        if not tInfoLp.get('isEditable') and tInfoLp.get('vType') == 't' and 'label' in tInfoLp:
                             label = tInfoLp['label'].lower()
                             val = tInfoLp.get('value')

                             if label in diskDataArr:
                                 if label == 'disktotal':
                                     device['dsk']['t'] = int(val)
                                 else:
                                     device['dsk']['u'] = int(val)
                             elif label in memDataArr:
                                 if label == 'memorytotal':
                                     device['mem']['t'] = int(val) / BYTES_RATIO
                                 else:
                                     device['mem']['u'] = int(val) / BYTES_RATIO

                    if not device['dsk']['t'] and not device['dsk']['u']:
                        del device['dsk']
                    if not device['mem']['t'] and not device['mem']['u']:
                        del device['mem']

            except Exception as e:
                logging.error(f"Error parsing info JSON: {e}")

        # Layouts count
        sql_l = f"""SELECT COALESCE(COUNT(DISTINCT fla.id), 0) as count FROM fldeviceassociation fld
			inner join flassignment fla on fld.assignmentId = fla.id
			inner join frameLayout fl on fla.layoutId = fl.id
			WHERE fld.deviceId = '{device_id}' and fla.isApproved = 1 and fl.isApproved = 1"""
        layouts = hub_functions.fetch_one(sql_l)
        device['frameLayout'] = layouts['count'] if layouts else 0

        history = hub_functions.getCount("devicemigrationhistory", {"deviceid": device_id})
        device['history'] = True if history else False

        # Device properties
        dp_sql = f"""SELECT dpa.id, dp.label, dpa.val AS value, dpa.vtype, dp.sort
			FROM devicepropertiesassociation AS dpa
			INNER JOIN deviceproperties dp ON dpa.dpid = dp.id
			WHERE dpa.deviceid = {device_id}
			ORDER BY dp.sort"""
        dp_res = hub_functions.query(dp_sql)
        dpPropArr = []
        if dp_res:
            for dres in dp_res:
                propExtraInfoArr = {}
                dres['vType'] = dres['vtype'] if dres['vtype'] else 't'
                if dres['vtype'] in ['d', 'dt', 'ti']:
                    # Date parsing check logic from PHP
                    # "isdate['error_count'] === 0 ..." handled inside changeResIfDate somewhat
                    propExtraInfoArr = hub_functions.changeResIfDate(dres['value'], dres['vtype'])

                del dres['vtype'] # PHP unset
                propInfoArr = {**dres, **propExtraInfoArr}
                dpPropArr.append(propInfoArr)

        device['properties'] = dpPropArr

        # License - placeholder
        licArr = {'id': device['guid'], 'lt': '', 'ie': '', 'aOn': '', 'gld': '', 'entity': '', 'bf': '', 'cur': '', 'bsd': ''}
        device['licId'] = licArr
        device['path'] = '/'
        device['uGroup'] = 0
        device['de'] = True

        return JSONResponse(content=device)
    else:
        return JSONResponse(content={'status': 'error', 'desc': 'Not Found or deleted', 'code': 4004})


@app.post("/action/devices")
async def action_devices(request: Request):
    try:
        req_body = await request.json()
        # req_body is list of dicts: [{"id": 106, "type": "device", ...}]
        # PHP: $request = (array) json_decode($app->request()->getBody(), true);

        ids = []
        buttonsArr = []
        folderIds = []
        info = [] # Should be dict in PHP ($info = array(...)) but sometimes used as list? PHP arrays are both.
                  # PHP: $info = array("edit" => ..., ) -> Dict.
                  # Later: $info = array_values($info) -> List.

        # We start as dict for lookups
        info_dict = {}

        isExistDvc = None
        dvcTypeArr = None

        # Iterate request
        if isinstance(req_body, list):
             for valuee in req_body:
                 v_type = valuee.get("type", "").lower()
                 if v_type == 'folder':
                     folderIds.append(valuee.get('id'))
                 elif v_type == 'device':
                     ids.append(valuee.get('id'))

        # Permissions
        if hub_functions.userPermissionArr:
             permissions = hub_functions.userPermissionArr
        else:
             permissions = hub_functions.userPermissions(SERVER_ID, USER_ID)

        idsArr = list(set(ids))
        idsArrLength = len(idsArr)
        folderIdsArr = list(set(folderIds))
        folderIdsArrLength = len(folderIdsArr)
        totalCount = folderIdsArrLength + idsArrLength

        if idsArr:
             dvcIds = ",".join(map(str, idsArr))
             # isExistDvc query
             sql_exist = f"select count(distinct fld.id) as count from flassignment as fl inner join fldeviceassociation as fld on fl.id = fld.assignmentid where fld.deviceid in ({dvcIds}) and fl.isapproved = 1"
             isExistDvc = hub_functions.fetch_one(sql_exist)

             # dvcTypeArr query
             sql_type = f"select ARRAY_TO_STRING(ARRAY_AGG(DISTINCT devicetype), ',') AS dt from device where id in ({dvcIds})"
             dvcTypeArr = hub_functions.fetch_one(sql_type)

        isMcCase = False
        isEslCase = False

        if "device_rights" in permissions:
             info_dict = {
                "edit": {"key": "dEdit", "code": 2005102, "desc": "Edit Device"},
                "delete": {"key": "dDelete", "code": 2005103, "desc": "Delete Device"},
                "edittags": {"key": "tEdit", "code": 2005108, "desc": "Edit Tags"},
                "addtogroup": {"key": "dAddToGroup", "code": 2005104, "desc": "Add Device Group"},
                "preview": {"key": "dPreview", "code": 2005130, "desc": "Device Preview"},
                "editfolder": {"key": "dEditFolder", "code": 2005132, "desc": "Edit Folder"},
                "move": {"key": "dMove", "code": 2005133, "desc": "Move"},
                "deletefolder": {"key": "dDeleteFolder", "code": 2005134, "desc": "Delete Folder"},
            }

             if totalCount > 1:
                 info_dict.pop("edit", None)
                 info_dict.pop("editfolder", None)

             if idsArrLength > 1:
                 info_dict.pop("delete", None)

             if folderIdsArrLength > 0:
                 info_dict.pop("edittags", None)
                 info_dict.pop("preview", None)

             if not folderIds:
                 info_dict.pop("editfolder", None)

             if "Move" in permissions["device_rights"]:
                 info_dict.pop("move", None)

             # Logic for buttonsArr
             # Branch 1: Single device
             if idsArrLength == 1 and totalCount == 1 and "Edit Device" in permissions["device_rights"]:
                  if "frame_layout_rights" in permissions and \
                     ("Edit assignment" in permissions["frame_layout_rights"] or "Assign" in permissions["frame_layout_rights"]) and \
                     isExistDvc and str(isExistDvc["count"]) == "0":

                         stepsArr = [
                            {"key": "dStep1", "label": "Assign Name"},
                            {"key": "dStep2", "label": "Assign Frame Layout"},
                            {"key": "dStep3", "label": "Assign Tags"}
                         ]
                         edit_tag = [
                            {"key": "tStep1", "label": "Assign Tags"},
                            {"key": "tStep2", "label": "Remove Tags"}
                         ]

                         dt = dvcTypeArr["dt"].lower() if dvcTypeArr and dvcTypeArr["dt"] else ""
                         if dt == "mc" or dt == EPD_LB:
                              stepsArr = [
                                {"key": "dStep1", "label": "Assign Name"},
                                {"key": "dStep3", "label": "Assign Tags"}
                              ]

                         buttonsArr = [
                            {"key": "dEdit", "label": "Edit", "steps": stepsArr},
                            {"key": "dMove", "label": "Move"},
                            {"key": "tEdit", "label": "Edit Tags", "steps": edit_tag},
                            {"key": "dAddToGroup", "label": "Add to Group"},
                            {"key": "dPreview", "label": "Preview"},
                            {"key": "dDelete", "label": "Delete"}
                         ]
                  else:
                       buttonsArr = [
                            {"key": "dEdit", "label": "Edit", "steps": [
                                {"key": "dStep1", "label": "Assign Name"},
                                {"key": "dStep3", "label": "Assign Tags"}
                            ]},
                            {"key": "dMove", "label": "Move"},
                            {"key": "tEdit", "label": "Edit Tags", "steps": [
                                {"key": "tStep1", "label": "Assign Tags"},
                                {"key": "tStep2", "label": "Remove Tags"}
                            ]},
                            {"key": "dAddToGroup", "label": "Add to Group"},
                            {"key": "dPreview", "label": "Preview"},
                            {"key": "dDelete", "label": "Delete"}
                        ]

             # Branch 2: Single Folder
             elif folderIdsArrLength == 1 and totalCount == 1:
                  buttonsArr = [
                    {"key": "dOpenFolder", "label": "Open Folder"},
                    {"key": "dEditFolder", "label": "Edit Folder"},
                    {"key": "dMove", "label": "Move"},
                    {"key": "dAddToGroup", "label": "Add to Group"},
                    {"key": "dDeleteFolder", "label": "Delete Folder"}
                  ]

             # Branch 3: Multiple selection or mixed
             else:
                  if idsArrLength > 1 and folderIdsArrLength == 0:
                       isAddToGroup = False
                       dt = dvcTypeArr["dt"].lower() if dvcTypeArr and dvcTypeArr["dt"] else ""
                       explode_notice = dt.split(",")

                       if "mc" in explode_notice or EPD_LB in explode_notice:
                            if dt == "mc" or dt == EPD_LB:
                                 isAddToGroup = True
                            else:
                                 isMcCase = True
                                 isEslCase = True
                                 info_dict["addtogroup"] = {"key": "dAddToGroup", "code": 2005112, "desc": "Selected devices contain music type device therefore you can not addtogroup"}
                                 info_dict["edittags"] = {"key": "editTags", "code": 2005131, "desc": "Selected devices contain music type device therefore you can not edit tag"}
                       else:
                            isAddToGroup = True

                       if isAddToGroup:
                            buttonsArr = [
                                {"key": "dMove", "label": "Move"},
                                {"key": "tEdit", "label": "Edit Tags", "steps": [
                                    {"key": "tStep1", "label": "Assign Tags"},
                                    {"key": "tStep2", "label": "Remove Tags"}
                                ]},
                                {"key": "dAddToGroup", "label": "Add to Group"}
                            ]

                       info_dict["delete"] = {"key": "dDelete", "code": 2005113, "desc": "Multiple devices can not be deleted at once."}

                  elif folderIdsArrLength > 1 and idsArrLength < 1:
                       buttonsArr = [
                        {"key": "dMove", "label": "Move"},
                        {"key": "dAddToGroup", "label": "Add to Group"},
                        {"key": "dDeleteFolder", "label": "Delete Folder"}
                       ]

                  elif folderIdsArrLength == 0:
                       buttonsArr = [
                        {"key": "dEdit", "label": "Edit"},
                        {"key": "tEdit", "label": "Edit tag"},
                        {"key": "dMove", "label": "Move"},
                        {"key": "dAddToGroup", "label": "Add to Group"},
                        {"key": "dPreview", "label": "Preview"},
                        {"key": "dDelete", "label": "Delete"}
                       ]

                  elif idsArrLength <= 1 and folderIdsArrLength >= 1:
                       buttonsArr = [
                        {"key": "dMove", "label": "Move"},
                        {"key": "dAddToGroup", "label": "Add to Group"}
                       ]
                       if "Delete Device" in permissions["device_rights"] and "Delete Folder" in permissions["device_rights"]:
                            buttonsArr.append({"key": "dDelete", "label": "Delete"})
                  else:
                       buttonsArr = [
                        {"key": "dMove", "label": "Move"},
                        {"key": "dAddToGroup", "label": "Add to Group"}
                       ]

             # Dashboard logic omitted for brevity, assuming standard user data

             if buttonsArr:
                  # Filter buttons based on permissions
                  # Device Preview
                  if "Device Preview" not in permissions["device_rights"]:
                      buttonsArr = [b for b in buttonsArr if b["key"] != "dPreview"]
                  else:
                      info_dict.pop("preview", None)

                  # Edit Group
                  if "Edit Group" not in permissions["device_rights"]:
                      buttonsArr = [b for b in buttonsArr if b["key"] != "dAddToGroup"]
                  else:
                      if not isMcCase or not isEslCase:
                          info_dict.pop("addtogroup", None)

                  # Edit Tag / Device
                  if ("Edit tag" not in permissions["device_rights"] or "Edit Device" not in permissions["device_rights"]):
                       buttonsArr = [b for b in buttonsArr if b["key"] != "tEdit"]
                  else:
                       if not isMcCase or not isEslCase:
                           info_dict.pop("edittags", None)

                  if "Edit Device" not in permissions["device_rights"]:
                       buttonsArr = [b for b in buttonsArr if b["key"] != "dEdit"]
                  else:
                       if not isMcCase or not isEslCase:
                           info_dict.pop("edit", None)

                  # MC case special
                  dt = dvcTypeArr["dt"].lower() if dvcTypeArr and dvcTypeArr["dt"] else ""
                  if idsArrLength == 1 and (dt == "mc" or dt == EPD_LB):
                       buttonsArr = [b for b in buttonsArr if b["key"] != "dPreview"]
                       isMcCase = True
                       isEslCase = True
                       tmp_cd = 2001123 if dt == "mc" else 2001124
                       info_dict["preview"] = {"key": "dPreview", "code": tmp_cd, "desc": f"Preview button can not show because selected device is {dvcTypeArr['dt']} type"}

                  # Delete Device
                  if "Delete Device" not in permissions["device_rights"]:
                       buttonsArr = [b for b in buttonsArr if b["key"] != "dDelete"]
                  elif idsArrLength == 1 or folderIdsArrLength > 0:
                       info_dict.pop("delete", None)

                  # Move
                  if "Move" not in permissions["device_rights"]:
                       buttonsArr = [b for b in buttonsArr if b["key"] != "dMove"]
                  else:
                       if not isMcCase or not isEslCase:
                            info_dict.pop("move", None)

                  # Edit Folder
                  if "Edit Folder" not in permissions["device_rights"]:
                       buttonsArr = [b for b in buttonsArr if b["key"] != "dEditFolder"]
                  else:
                       info_dict.pop("editfolder", None)

                  # Delete Folder
                  if "Delete Folder" not in permissions["device_rights"]:
                       buttonsArr = [b for b in buttonsArr if b["key"] != "dDeleteFolder"]
                  else:
                       info_dict.pop("deletefolder", None)

                  # Mixed selection logic for delete/deleteFolder keys in info_dict
                  if idsArrLength <= 1 and folderIdsArrLength >= 1:
                       if "Delete Device" not in permissions["device_rights"] and "Delete Folder" in permissions["device_rights"]:
                            info_dict["delete"] = {"key": "dDelete", "code": 2005103, "desc": "Delete Device"}
                            info_dict.pop("deletefolder", None)
                       if "Delete Device" in permissions["device_rights"] and "Delete Folder" not in permissions["device_rights"]:
                            info_dict["deletefolder"] = {"key": "dDeleteFolder", "code": 2005134, "desc": "Delete Folder"}
                            info_dict.pop("delete", None)
                       if "Delete Device" not in permissions["device_rights"] and "Delete Folder" not in permissions["device_rights"]:
                            info_dict["delete"] = {"key": "dDelete", "code": 2005103, "desc": "Delete Device"}
                            info_dict["deletefolder"] = {"key": "dDeleteFolder", "code": 2005134, "desc": "Delete Folder"}

                       if idsArrLength < 1 and folderIdsArrLength >= 1:
                            info_dict.pop("delete", None)

        # Final info processing
        # $info = ($isAdmin && (!$isMcCase || !$isEslCase) && $idsArrLength == 1) ? array() : array_values($info);
        final_info = []
        if IS_ADMIN and (not isMcCase or not isEslCase) and idsArrLength == 1:
             final_info = [] # array() empty
        else:
             final_info = list(info_dict.values())

        data = {"info": final_info, "buttons": buttonsArr}
        return JSONResponse(content=data)

    except Exception as e:
        logging.error(f"Error in action_devices: {e}")
        return JSONResponse(content={"status": "error", "message": str(e)}, status_code=500)
