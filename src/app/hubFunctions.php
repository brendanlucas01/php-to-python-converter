<?php
class hubFunctions {
	public $app;
    private $medoo;

    public $error_500 = '{"status": "error", "code": 5000, "desc": "Something went wrong!!!"}';

	function __construct($app, $db = 'hub', $user = 'postgres', $password = 'postgres', $host = 'localhost'){
		$conn = new Medoo\Medoo(array(
            'database_type' =>'pgsql',
            'database_name' => $db,
            'server'=> $host,
            'username' => $user,
            'password' => $password,
            'charset' => 'utf8',
            'option' => array(
                PDO::ATTR_CASE=>PDO::CASE_NATURAL
            )
		));

		$this->medoo = $conn;

		$this->app = $app;
	}

	function getOne($table, $columns, $condition, $join=array()){
		try{
			if(empty($join)){
				$res = $this->medoo->get(
					$table,
					$columns,
					$condition
				);
			}
			else{
				$res = $this->medoo->get(
					$table,
					$join,
					$columns,
					$condition
				);
			}
		}
		catch(Exception $e){
			if($this->app->config('debug') == 'development'){
				$this->app->halt(500, $e->getTraceAsString());
			}
			else{
				$this->app->response()->headers->set('Content-Type', 'application/json');
				$this->app->halt(500, $this->error_500);
			}
		}

		return $res;
	}

	function getSpecific($table, $columns, $condition, $join=array()){
		try{
			if(empty($join)){
				$res = $this->medoo->select(
					$table,
					$columns,
					$condition
				);
			}
			else{
				$res = $this->medoo->select(
					$table,
					$join,
					$columns,
					$condition
				);
			}
		}
		catch(Exception $e){
			if($this->app->config('debug') == 'development'){
				$this->app->halt(500, $e->getTraceAsString());
			}
			else{
				$this->app->response()->headers->set('Content-Type', 'application/json');
				$this->app->halt(500, $this->error_500);
			}
		}

		return $res;
	}

	function getCount($table, $condition, $column='', $join=array()){
		try{
			if(empty($join)){
				$res = $this->medoo->count(
					$table,
					$condition
				);
			}
			else{
				$res = $this->medoo->count(
					$table,
					$join,
					$column,
					$condition
				);
			}
		}
		catch(Exception $e){
			if($this->app->config('debug') == 'development'){
				$this->app->halt(500, $e->getTraceAsString());
			}
			else{
				$this->app->response()->headers->set('Content-Type', 'application/json');
				$this->app->halt(500, $this->error_500);
			}
		}

		return $res;
	}

	function query($sql){
		try{
			$res = $this->medoo->query($sql);
		}
		catch(Exception $e){
			if($this->app->config('debug') == 'development'){
				$this->app->halt(500, $e->getTraceAsString());
			}
			else{
				$this->app->response()->headers->set('Content-Type', 'application/json');
				$this->app->halt(500, $this->error_500);
			}
		}

		return $res;
	}

	function prepare_and_execute($sql, $params = array()){
		try{
			$res = $this->medoo->pdo->prepare($sql);

			if(!empty($params)){
				foreach($params as $key => &$val){
					$res->bindParam($key, $val);
				}
			}

			$res->execute();
		}
		catch(Exception $e){
			if($this->app->config('debug') == 'development'){
				$this->app->halt(500, $e->getTraceAsString());
			}
			else{
				$this->app->response()->headers->set('Content-Type', 'application/json');
				$this->app->halt(500, $this->error_500);
			}
		}

		return $res;
	}

	function echoResponse($responseArray, $httpCode = 200){
		if($httpCode != 200){
			$this->halt($httpCode, $responseArray);
		}
		$this->app->response->setStatus($httpCode);
		//This returns the Content-Type header’s full value as provided by the HTTP client
		//$mediaType = $this->app->request()->getContentType();

		//You may not want the complete Content-Type header? then use this method
		$mediaType = $this->app->request()->getMediaType();
		if($mediaType == "application/xml"){
			$this->app->response()->headers->set('Content-Type', $mediaType);
			$xml = new SimpleXMLElement("<?xml version=\"1.0\"?><root></root>");
			$this->arrayToXML($responseArray, $xml);
			$this->app->response->write($xml->asXML());
		}
		else{
			$this->app->response()->headers->set('Content-Type', 'application/json');
			$responseJson = json_encode($responseArray);
			$encoding = $this->app->request->headers->get('ACCEPT_ENCODING');
			if(!empty($encoding) && strpos(strtolower($encoding), 'gzip') !== false){
				$this->app->response()->headers->set('Content-Encoding', 'gzip');
				$responseJson = gzencode($responseJson);
			}
			$this->app->response()->headers->set('Content-Length', strlen($responseJson));
			$this->app->response->write($responseJson);
		}
		$this->app->stop();
	}

	function halt($httpCode, $message = ''){
		http_response_code($httpCode);
		if(is_array($message)){
			$message = json_encode($message);
		}
		die($message);
	}

	//function for convert array to xml
	function arrayToXML($array, &$xml){
		foreach($array as $key => $value) {
			if(is_array($value)) {
				if(!is_numeric($key)){
					$subnode = $xml->addChild("$key");
					$this->arrayToXML($value, $subnode);
				}
				else{
					$subnode = $xml->addChild("item$key");
					$this->arrayToXML($value, $subnode);
				}
			}
			else{
				$xml->addChild("$key", htmlspecialchars("$value"));
			}
		}
	}

	function getUserTimebyZone($uid, $time){
		$usersDetails = $this->query("SELECT tz.timezone, u.lang FROM \"user\" u LEFT JOIN timezone tz ON u.timezone = tz.label WHERE u.id = $uid")->fetch(PDO::FETCH_ASSOC);

		$d = $this->getCurretTime($usersDetails['timezone'], $time);
		$finalDate = date("F j, Y", $d);
		$finalDateTime = date("F j, Y | g:i A", $d);

		$date = new DateTime($time);
		$dateTimeStamp = $date->getTimestamp();

		$userDetails = array("timezone" => $usersDetails['timezone'], "lang" => $usersDetails['lang'], 'date' => $finalDate, 'datetime' => $finalDateTime, 'timestamp' => $dateTimeStamp);
		return $userDetails;
	}

	function getCurretTime($timezone, $datetime){
		$dateArr = str_split($datetime, '10');
		$dateExtractArr = $dateArr[0];
		$timeExtractArr = $dateArr[1];

		if(substr($timezone, 4, 6) >= 0){
			$time = substr($timezone, 5, 5).':00';
			$parsed = date_parse($time);
			$minutes = ($parsed['hour'] * 3600 + $parsed['minute'] * 60 + $parsed['second']) / 60;
			$endTime = strtotime("+".$minutes." minutes", strtotime($timeExtractArr));
			$curretTime = date('h:i:s A', $endTime);
		}
		else{
			$time = substr($timezone, 5, 5).':00';
			$parsed = date_parse($time);
			$minutes = ($parsed['hour'] * 3600 + $parsed['minute'] * 60 + $parsed['second']) / 60;
			$endTime = strtotime("-".$minutes." minutes", strtotime($timeExtractArr));
			$curretTime = date('h:i:s A', $endTime);
		}
		$dateAns = strtotime($dateExtractArr.' '.$curretTime);
		return $dateAns;
	}

	function getUserDeviceTag($ugIds, $sid, $usersort = 'label', $emptyTag = false, $dId = false, $hideMcTag = false, $calledFrom = ""){
		if(isset($ugIds) && isset($sid)){
			$usersort = str_replace("name", "label", $usersort);
			$extraSQL = "";
			$mcTagArr = array();

			if($dId){
				if($calledFrom == 'deviceList'){
					$extraSQL = "AND dp.deviceid IN ($dId)";
				}
				else{
					$extraSQL = "AND dp.deviceid = $dId";
				}
			}

			if($hideMcTag){
				$mcTagArr = $this->query("select COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT dta.tagid), ','), '0') as tagids from device d inner join devicetagassociation dta on d.id = dta.deviceid where d.serverid = $sid and d.devicetype = 'mc'")->fetch(PDO::FETCH_ASSOC);
			}

			// If folder hasn't accessible by user but device under that folder is public and that device is in a device group than that device group should not be visible to user.
			$dvcfolder_whr_cndtn = '';
			/* $server_info = $this->getOne("hubcp\".\"server", array("devicegrouping"), array("id" => $sid));

			if(!empty($server_info['devicegrouping']) && $server_info['devicegrouping'] == 'df'){
				$accessibleFolders = $this->getAccessibledeviceFolderIds($sid, $ugIds);
				$dvcfolder_whr_cndtn = "d.folderid IN(". implode(',', array_unique($accessibleFolders)).") AND";
			} */

			$allDevices = $this->query("select COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT d.id), ','), '0') as deviceids from device d INNER JOIN devicePermission dp ON d.id = dp.deviceId where $dvcfolder_whr_cndtn dp.userGroupId IN ($ugIds) AND isActive = 1 and serverId = $sid")->fetch(PDO::FETCH_ASSOC);
			$allDevicesArr = ($allDevices['deviceids'] != '0') ? explode(',', $allDevices['deviceids']) : array();
			if($emptyTag){
				$usersort = str_replace('d.', '', $usersort);
				$deviceTags = $this->query("select * from
				(
					(
						SELECT distinct dt.id, dt.name as label, dt.createdon, dt.createdby as \"createdBy\", dt.color as \"tagColor\", (SELECT COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT deviceid), ','), '') FROM devicetagassociation WHERE tagid = dt.id) as deviceids
						FROM devicetag as dt left join devicetagassociation as d1 on d1.tagid = dt.id
						left join devicePermission as dp on d1.deviceId = dp.deviceId
						where dt.serverId = $sid and (dp.userGroupId in ($ugIds)) $extraSQL group by dt.id
					)
					UNION
					(
						SELECT distinct d.id, d.name as label, d.createdon, d.createdby as \"createdBy\",
						d.color as \"tagColor\", '' as deviceids
						FROM devicetag AS d
						left join devicetagassociation as d1 on d1.tagid = d.id
						WHERE d.serverId = $sid AND d1.id IS NULL
					)
				) AS deviceAll order by $usersort")->fetchAll(PDO::FETCH_ASSOC);
			}
			else{
				$usersort = str_replace("label", "dt.name", $usersort);
				$deviceTags = $this->query("SELECT distinct dt.id, UPPER(dt.name), dt.name as label, dt.createdon, dt.createdby as \"createdBy\", dt.color as \"tagColor\", (SELECT COALESCE(ARRAY_TO_STRING(ARRAY_AGG(DISTINCT deviceid), ','), '') FROM devicetagassociation WHERE tagid = dt.id) as deviceids
						FROM devicetag as dt left join devicetagassociation as d1 on d1.tagid = dt.id
						left join devicePermission as dp on d1.deviceId = dp.deviceId
						where dt.serverId = $sid and (dp.userGroupId in ($ugIds)) $extraSQL order by $usersort")->fetchAll(PDO::FETCH_ASSOC);
			}

			$accTags = array();
			if($deviceTags){
				$mcTagArr = !empty($mcTagArr["tagids"]) ? explode(",", $mcTagArr["tagids"]) : array();
				foreach($deviceTags as $dt){
					// here we chk if normal user logged in, and if device tag contains atleast a device which is not accessible, then never show that type of tag,
					$dt['createdOn'] = $dt['createdon'];
					if($dt['deviceids'] != ''){
						$explode_notice = explode(',', $dt['deviceids']);
						$arrNotAccessible = array_diff($explode_notice, $allDevicesArr);
						if(!empty($arrNotAccessible) || in_array($dt["id"], $mcTagArr)){
							continue;
						}
					}

					if($calledFrom == 'deviceList'){
						unset($dt["upper"], $dt['createdon']);
					}
					else{
						unset($dt["deviceids"], $dt["upper"], $dt['createdon']);
					}

					$accTags[] = $dt;
				}
			}
			return $accTags;
		}
		else{
			return false;
		}
	}

    /**
	 *  @brief Where condition for - ARRAYs
	 *
	 *  @param [in] $arr array in which we want to search value of a key
	 *  @param [in] $key single key to be searched
	 *  @param [in] $val value of the key to be matched
	 *  @param [in] $op operator - equal or not equal
	 *  @return matched search array
	 *
	 *  @details https://paiza.io/projects/CJp4nSrSkBnFHoSXNHNv_A?language=php
	 */
	function searchInArray($arr, $key, $val, $op, $delimiter = ','){
		$arr_new = array();
		sort($arr);
		if(is_array($val)){
			sort($val);
		}

		if($op == 'in'){
			foreach($arr as $x){
				if(isset($x[$key])){
					$x_key = $x[$key];
					if(!is_array($x[$key])){
						$x_key = explode($delimiter, $x[$key]);
					}

					$x_flip = array_flip($x_key);
					if(isset($x_flip[$val])){
						$arr_new[] = $x; // this will only return elements where $key exists and $val exists in the array assigned on the $key
					}
				}
			}
		}
		else if($op == 'any'){
			if(!is_array($val)){
				$val = explode($delimiter, $val);
			}
			$val_flip = array_flip($val);

			foreach($arr as $x){
				if(isset($x[$key]) && isset($val_flip[$x[$key]])){
					$arr_new[] = $x; // this will only return elements where $key exists and $key is equal to any value in array $val
				}
			}
		}
		else if($op == 'none'){
			if(!is_array($val)){
				$val = explode($delimiter, $val);
			}
			$val_flip = array_flip($val);

			foreach($arr as $x){
				if(!isset($x[$key]) || !isset($val_flip[$x[$key]])){
					$arr_new[] = $x; // this will only return elements where $key does not exists or $key is not equal to any value in array $val
				}
			}
		}
		else if($op == 'common'){
			if(!is_array($val)){
				$val = explode($delimiter, $val);
			}

			foreach($arr as $x){
				if(isset($x[$key])){
					$x_key = $x[$key];
					if(!is_array($x[$key])){
						$x_key = explode($delimiter, $x[$key]);
					}

					if(array_intersect($x_key, $val)){
						$arr_new[] = $x; // this will only return elements where $key exists, and $key and any value in array $val are common
					}
				}
			}
		}
		else if($op == 'all'){
			if(!is_array($val)){
				$val = explode($delimiter, $val);
			}

			foreach($arr as $x){
				if(isset($x[$key])){
					$x_key = $x[$key];
					if(!is_array($x[$key])){
						$x_key = explode($delimiter, $x[$key]);
					}

					if($x_key == array_intersect($x_key, $val)){
						$arr_new[] = $x; // this will only return elements where $key exists, and $key and all value in array $val are common
					}
				}
			}
		}
		else if($op == 'eq'){
			foreach($arr as $x){
				if(isset($x[$key]) && $x[$key] == $val){
					$arr_new[] = $x; // this will only return elements where $key exists and is equal to $val
				}
			}
		}
		else if($op == 'eqi'){
			foreach($arr as $x){
				if(isset($x[$key]) && strtolower($x[$key]) == strtolower($val)){
					$arr_new[] = $x; // this will only return elements where $key exists and is equal to $val (case insensitive)
				}
			}
		}
		else if($op == 'ne'){
			foreach($arr as $x){
				if(!isset($x[$key]) || $x[$key] != $val){
					$arr_new[] = $x; // this will only return elements where $key does not exists or is not equal to $val
				}
			}
		}
		else if($op == 'nei'){
			foreach($arr as $x){
				if(!isset($x[$key]) || strtolower($x[$key]) != strtolower($val)){
					$arr_new[] = $x; // this will only return elements where $key does not exists or is not equal to $val (case insensitive)
				}
			}
		}
		else if($op == 'ge'){
			foreach($arr as $x){
				if(isset($x[$key]) && $x[$key] >= $val){
					$arr_new[] = $x; // this will only return elements where $key exists and is greater or equal to $val
				}
			}
		}
		else if($op == 'le'){
			foreach($arr as $x){
				if(isset($x[$key]) && $x[$key] <= $val){
					$arr_new[] = $x; // this will only return elements where $key exists and is lesser or equal to $val
				}
			}
		}

		return $arr_new;
	}

	function changeResIfDate($val, $vtype = 'd'){
		$given = new DateTime($val);
		$newRwlabel = $given->format('m/d/Y H:i:s');
		$dateOnly = $given->format('m/d/Y');
		$timeOnly = $given->format('H:i:s');
		$newRwTime = $given->format('Y-m-d').'T'.$timeOnly;

		$InfoNewArr = array(
			'time' => $newRwTime,
			'vType' => $vtype,
		);

		if($vtype == 'd' || $vtype == 'dt'){
			$InfoNewArr['dateRange'] = array("startDate" => $dateOnly, "endDate" => $dateOnly);
		}

		return $InfoNewArr;
	}

	function userPermissions($sid, $uid){
        $allowed = array(
            'device_rights' => array('Edit Device', 'Edit Group', 'Edit tag', 'Delete Device', 'Edit Folder', 'Delete Folder', 'Move', 'Device Preview'),
            'frame_layout_rights' => array('Assign', 'Edit assignment'),
        );

		return $allowed;
	}
}