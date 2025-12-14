<?php
require dirname(__DIR__) . '/vendor/autoload.php';
require dirname(__DIR__) . '/app/hubFunctions.php';

$serverId = 2;
$userId = 1;
$isAdmin = 1;
$userGroupDetails = array(0);
$data = array(
    "userDetails" => array(
        "serverId" => $serverId,
        "userId" => $userId,
        "isAdmin" => $isAdmin,
        "userGroupDetails" => $userGroupDetails
    )
);
$userData = $data["userDetails"];

define('ID_or_CommaID', '/^(\d(\,\d)*)+$/');
define("BYTES_RATIO", 1024); // ex. 1024 bytes in 1 MB
define('EPD_LB', 'epd');

use Medoo\Medoo;
$app = new \Slim\Slim();
$app->config(array(
	'debug' => getenv('APP_DEBUG'),
	'mode' => getenv('APP_ENV'),
	'routes.case_sensitive' => false
));

$app->container->singleton('hubFunctions', function(){
	$app = \Slim\Slim::getInstance();
	$hubFunctions = new hubFunctions($app, getenv('DB_DATABASE'), getenv('DB_USERNAME'), getenv('DB_PASSWORD'), 'db');

	return $hubFunctions;
});

$app->get('/', function () {
    echo "Hello World";
});

$app->get('/hi', function () {
    echo "Hi World";
});

$app->get('/devices', function () use ($app){
    $us = $app->hubFunctions->query("SELECT * FROM public.device")->fetchAll(PDO::FETCH_ASSOC);
    $app->hubFunctions->echoResponse($us);
});

$app->get('/devices/briefs/:deviceId', function($deviceId) use($app, $serverId, $userId, $isAdmin, $userGroupDetails){
	if(preg_match(ID_or_CommaID, $deviceId)){
		// $app->hubFunctions->validateItemAccess($serverId, $userId, 'device', $deviceId, $userGroupDetails, $isAdmin);

		$device = $app->hubFunctions->query("select d.id, d.name, d.hardwareid as eip, COALESCE(NULLIF(d.watcherVersion, ''), null) AS watcher, u.fname || ' ' || u.lname AS \"createdBy\", d.autoUpdate as update, COALESCE(d.offlineReboot, 0) as \"offlineReboot\", thumbversion AS tv, ds.screenshotcapture as ss, COALESCE(NULLIF(slideversion, ''), null) AS slide, d.publicip as \"publicIP\", d.localip as \"localIP\", resolution as res, computername AS \"cName\", d.guid, os, client, ds.desktoprefreshrate AS \"refreshRate\", ds.desktopcolordepth AS \"colorDepth\", d.timezone, d.isticket AS \"isTicket\", d.info, COALESCE(d.createdon, null) as \"createdOn\"
		from device as d
		left join devicesetting ds on d.id = ds.deviceid
		left join \"user\" as u on d.createdBy = u.id
		where d.isActive = 1 and d.serverId = ".$serverId." and d.id = ".$deviceId)->fetch(PDO::FETCH_ASSOC);
		if($device){
			if(!empty($device['createdOn'])){
				$dates = $app->hubFunctions->getUserTimebyZone($userId, $device["createdOn"]);
				$device['createdOn'] = $dates["timestamp"];
			}

			$device['adapters'] = $app->hubFunctions->getSpecific("deviceextraips", array("hardwareid(mac)", "description"), array("deviceid" => $deviceId));
			$device['timezone'] = array('label' => $device['timezone']);

			$userGroupDetails_str = implode(',', $userGroupDetails);

			// schedules count
			if($isAdmin){
				$schedules = $app->hubFunctions->query("SELECT COALESCE( ARRAY_TO_STRING( ARRAY_AGG( s.id ), ','), '0') as scheduleids FROM scheduledeviceassociation left join schedule s on s.id = scheduledeviceassociation.scheduleId WHERE (scheduledeviceassociation.deviceId = ".$deviceId.") AND s.isApproved = 1 and s.isActive = 1 AND s.endDate >= '".date('Y-m-d H:i:s')."' AND s.isCompleted = 1 AND s.startDate IS NOT NULL")->fetch(PDO::FETCH_ASSOC);

				$inactive_schedules = $app->hubFunctions->query("SELECT COALESCE( ARRAY_TO_STRING( ARRAY_AGG( s.id ), ','), '0') as scheduleids FROM scheduledeviceassociation left join schedule s on s.id = scheduledeviceassociation.scheduleId WHERE (scheduledeviceassociation.deviceId = ".$deviceId.") AND s.isApproved = 1 and s.isActive = 0 AND s.endDate >= '".date('Y-m-d H:i:s')."' AND s.isCompleted = 1 AND s.startDate IS NOT NULL")->fetch(PDO::FETCH_ASSOC);

				$tagCount = $app->hubFunctions->query("SELECT count(DISTINCT d.tagid) as \"tagCount\" FROM devicetagassociation as d WHERE d.deviceId = ".$deviceId."")->fetch(PDO::FETCH_ASSOC);
			}
			else{
				$schedules = $app->hubFunctions->query("SELECT COALESCE( ARRAY_TO_STRING( ARRAY_AGG( s.id ), ','), '0') as scheduleids FROM scheduledeviceassociation left join schedule s on s.id = scheduledeviceassociation.scheduleId INNER JOIN schedulepermission sp ON s.id = sp.scheduleId WHERE (scheduledeviceassociation.deviceId = ".$deviceId.") AND s.isApproved = 1 and s.isActive = 1 AND s.endDate >= '".date('Y-m-d H:i:s')."' AND s.isCompleted = 1 AND s.startDate IS NOT NULL AND sp.userGroupId IN (".$userGroupDetails_str.")")->fetch(PDO::FETCH_ASSOC);

				$inactive_schedules = $app->hubFunctions->query("SELECT COALESCE( ARRAY_TO_STRING( ARRAY_AGG( s.id ), ','), '0') as scheduleids FROM scheduledeviceassociation left join schedule s on s.id = scheduledeviceassociation.scheduleId INNER JOIN schedulepermission sp ON s.id = sp.scheduleId WHERE (scheduledeviceassociation.deviceId = ".$deviceId.") AND s.isApproved = 1 and s.isActive = 0 AND s.endDate >= '".date('Y-m-d H:i:s')."' AND s.isCompleted = 1 AND s.startDate IS NOT NULL AND sp.userGroupId IN (".$userGroupDetails_str.")")->fetch(PDO::FETCH_ASSOC);

				$tagCount['tagCount'] = count($app->hubFunctions->getUserDeviceTag($userGroupDetails_str, $serverId, 'label', false, $deviceId));
			}

			$device['tag'] = $tagCount ? $tagCount['tagCount'] : 0;
			$explode_notice = explode(',', $schedules['scheduleids']);
			$explode_notice = array_filter($explode_notice);
			$scheduleIdsArr = array_unique($explode_notice);

			$explode_notice = explode(',', $inactive_schedules['scheduleids']);
			$explode_notice = array_filter($explode_notice);
			$inactive_scheduleIdsArr = array_unique($explode_notice);

			$device['schedule'] = array('a' => $schedules ? count($scheduleIdsArr) : 0, 'i' => $inactive_schedules ? count($inactive_scheduleIdsArr) : 0);

			$contents = false;
			if(!empty($scheduleIdsArr)){
				$contentCondition = " AND schedule.id IN (".implode(',', $scheduleIdsArr).") "; //added later in below content query

				if($isAdmin){
					$contents = $app->hubFunctions->query("SELECT COALESCE(COUNT(schedulecontentassociation.contentId), 0) as count FROM schedule
					LEFT JOIN schedulecontentassociation ON schedule.id = schedulecontentassociation.scheduleId
					LEFT JOIN contentLibrary ON contentLibrary.id = schedulecontentassociation.contentId
					WHERE contentLibrary.status = '0' $contentCondition AND contentLibrary.isApproved = '1'")->fetch(PDO::FETCH_ASSOC);
				}
				else{
					$app->hubFunctions->upToRootFolderIds = '';
					// $accFolderIds = $app->hubFunctions->getFolderIdsUpToLeaf(0, $userGroupDetails_str, $userId, $serverId);
					$accFolderIds = '0';

					$app->hubFunctions->upToRootFolderIds = '';
					// $accTFolderIds = $app->hubFunctions->getTemplateFolderIdsUpToLeaf(0, $userGroupDetails_str, $userId, $serverId);
					$accTFolderIds = '0';

					$contents = $app->hubFunctions->query("SELECT COALESCE(COUNT(schedulecontentassociation.contentId), 0) as count
					FROM schedule
					LEFT JOIN schedulecontentassociation ON schedule.id = schedulecontentassociation.scheduleId
					LEFT JOIN contentLibrary ON contentLibrary.id = schedulecontentassociation.contentId
					INNER JOIN contentpermission ON contentLibrary.id = contentpermission.contentId
					WHERE contentLibrary.status = '0' $contentCondition AND contentLibrary.isApproved = '1' AND contentpermission.usergroupid IN (".$userGroupDetails_str.") AND
					(
						( ( contentLibrary.restorefolderid IN (".$accFolderIds.") OR contentLibrary.restorefolderid IS NULL ) AND contentLibrary.type != 101 ) OR
						( ( contentLibrary.restorefolderid IN (".$accTFolderIds.") OR contentLibrary.restorefolderid IS NULL ) AND contentLibrary.type = 101 )
					)")->fetch(PDO::FETCH_ASSOC);
				}
			}


			$inactive_contents = false;
			if(!empty($inactive_scheduleIdsArr)){
				$inactive_contentCondition = " AND schedule.id IN (".implode(',', $inactive_scheduleIdsArr).") "; //added later in below content query

				// content count
				if($isAdmin){
					$inactive_contents = $app->hubFunctions->query("SELECT COALESCE(COUNT(schedulecontentassociation.contentId), 0) as count FROM schedule
					LEFT JOIN schedulecontentassociation ON schedule.id = schedulecontentassociation.scheduleId
					LEFT JOIN contentLibrary ON contentLibrary.id = schedulecontentassociation.contentId
					WHERE schedule.isActive = 0 AND contentLibrary.status = '0' $inactive_contentCondition AND contentLibrary.isApproved = '1' AND contentLibrary.serverId = ".$serverId)->fetch(PDO::FETCH_ASSOC);
				}
				else{
					$accFolderIds = $app->hubFunctions->getFolderIdsUpToLeaf(0, $userGroupDetails_str, $userId, $serverId);
					$inactive_contents = $app->hubFunctions->query("SELECT COALESCE(COUNT(schedulecontentassociation.contentId), 0) as count FROM schedule
					LEFT JOIN schedulecontentassociation ON schedule.id = schedulecontentassociation.scheduleId
					LEFT JOIN contentLibrary ON contentLibrary.id = schedulecontentassociation.contentId
					INNER JOIN contentpermission ON contentLibrary.id = contentpermission.contentId
					WHERE schedule.isActive = 0 AND contentLibrary.status = '0' $inactive_contentCondition AND contentLibrary.isApproved = '1' AND contentLibrary.serverId = ".$serverId." AND contentpermission.usergroupid IN (".$userGroupDetails_str.") AND (contentLibrary.restorefolderid IN (".$accFolderIds.") OR contentLibrary.restorefolderid IS NULL)")->fetch(PDO::FETCH_ASSOC);
				}
			}

			$device['content'] = array('a' => $contents ? $contents['count'] : 0, 'i' => $inactive_contents ? $inactive_contents['count'] : 0);
			// $device['eip'] = $app->hubFunctions->encrypt_decrypt('encrypt', $device['eip']);
			$device['eip'] = '';

			if($device['os'] == 4){
				$device['watcher'] = null;
			}

			$device['osv'] = null;
			if(!empty($device['info'])){
				$infoArr = (array) json_decode($device['info'], true);
				if(!empty($infoArr)){
					if($device['os'] == 2){
						$webos = $app->hubFunctions->searchInArray($infoArr, 'label', 'WebOS', 'eqi');
						$webos = $app->hubFunctions->searchInArray($webos, 'isEditable', false, 'eq');
						$webos = $app->hubFunctions->searchInArray($webos, 'vType', 't', 'eqi');
						if(!empty($webos[0]['value'])){
							$device['osv'] = $webos[0]['value'];
						}
					}
					else if($device['os'] == 3){
						$tizenV = $app->hubFunctions->searchInArray($infoArr, 'label', 'Tizen', 'eqi');
						$tizenV = $app->hubFunctions->searchInArray($tizenV, 'isEditable', false, 'eq');
						$tizenV = $app->hubFunctions->searchInArray($tizenV, 'vType', 't', 'eqi');
						if(!empty($tizenV[0]['value'])){
							$device['osv'] = $tizenV[0]['value'];
						}
					}

					$diskDataArr = array('disktotal', 'diskused');
					$memDataArr = array('memorytotal', 'memoryused');

					$device['dsk'] = $device['mem'] = array('t' => null, 'u' => null);

					foreach($infoArr as $tInfoLp){
						if(
							empty($tInfoLp['isEditable']) &&
							isset($tInfoLp['vType']) &&
							$tInfoLp['vType'] == 't' &&
							isset($tInfoLp['label'])
						){
							$tInfoLp['label'] = strtolower($tInfoLp['label']);

							if(in_array($tInfoLp['label'], $diskDataArr)){
								if($tInfoLp['label'] == 'disktotal'){
									$device['dsk']['t'] = intval($tInfoLp['value']);
								}
								else{
									$device['dsk']['u'] = intval($tInfoLp['value']);
								}
							}
							else if(in_array($tInfoLp['label'], $memDataArr)){
								if($tInfoLp['label'] == 'memorytotal'){
									$device['mem']['t'] = intval($tInfoLp['value']) / BYTES_RATIO;
								}
								else{
									$device['mem']['u'] = intval($tInfoLp['value']) / BYTES_RATIO;
								}
							}
						}
					}

					if(empty($device['dsk']['t']) && empty($device['dsk']['u'])){
						unset($device['dsk']);
					}

					if(empty($device['mem']['t']) && empty($device['mem']['u'])){
						unset($device['mem']);
					}
				}
			}

			// layouts count
			$layouts = $app->hubFunctions->query("SELECT COALESCE(COUNT(DISTINCT fla.id), 0) as count FROM fldeviceassociation fld
			inner join flassignment fla on fld.assignmentId = fla.id
			inner join frameLayout fl on fla.layoutId = fl.id
			WHERE fld.deviceId = '".$deviceId."' and fla.isApproved = 1 and fl.isApproved = 1")->fetch(PDO::FETCH_ASSOC);
			$device['frameLayout'] = $layouts ? $layouts['count'] : 0;

			$history = $app->hubFunctions->getCount("devicemigrationhistory", array("deviceid" => $deviceId));
			$device['history'] = $history ? true : false;

			// device properties
			$dp_res = $app->hubFunctions->query("SELECT dpa.id, dp.label, dpa.val AS value, dpa.vtype, dp.sort
			FROM devicepropertiesassociation AS dpa
			INNER JOIN deviceproperties dp ON dpa.dpid = dp.id
			WHERE dpa.deviceid = $deviceId
			ORDER BY dp.sort")->fetchAll(PDO::FETCH_ASSOC);
			$dpPropArr = array();
			if(!empty($dp_res)){
				foreach ($dp_res as $dres) {
					$propExtraInfoArr= array();
					$dres['vType'] = !empty($dres['vtype']) ? $dres['vtype'] : 't';
					if(!empty($dres['vtype']) && ($dres['vtype'] == 'd' || $dres['vtype'] == 'dt' || $dres['vtype'] == 'ti')){
						$isdate = date_parse($dres['value']);
						if($isdate['error_count'] === 0 && $isdate['warning_count'] === 0 && ($isdate['month'] != false || $isdate['day'] != false || $isdate['year'] != false || $isdate['hour'] != false || $isdate['minute'] != false || $isdate['second'] != false)){
							$propExtraInfoArr = $app->hubFunctions->changeResIfDate($dres['value'], $dres['vtype']);
						}
					}
					unset($dres['vtype']);
					$propInfoArr = array_merge($dres, $propExtraInfoArr);
					$dpPropArr[] = $propInfoArr;
				}
			}
			$device['properties'] = $dpPropArr;

			// license
			$licArr = array('id' => $device['guid'], 'lt' => '', 'ie' => '', 'aOn' => '', 'gld' => '', 'entity' => '', 'bf' => '', 'cur' => '', 'bsd' => '');
			/* if(!empty($device['guid'])){
				$tokenDataArr = array();
				$tokenDataArr['exp'] = time() + 15;
				$tokenDataArr['userId'] = JWT_USER_KEY;
				$jwtToken = $app->hubFunctions->generateJWTToken($tokenDataArr, 'HS256', JWT_SECRET_KEY_CPQ);
				$jwtHeader = array(
					'Authorization: ' .$jwtToken,
					'Accept: application/json',
					'Content-Type: application/json'
				);
				$licenseDetailUrl = ORDER_PORTAL_URL."license/licenseDetails/".$serverId."/".$device['guid']."/".SUPPORT_DESK_ENV_ID;
				$licenseDetailresponseArr = $app->hubFunctions->exec_curl($licenseDetailUrl, array(), $jwtHeader, 'GET');
				$licenseDetailResponse = (array) json_decode($licenseDetailresponseArr, true);
				if(!empty($licenseDetailResponse['i'])){
					$licArr = $licenseDetailResponse;
				}
			} */
			$device['licId'] = $licArr;

			// $device['path'] = $app->hubFunctions->getDevicePath($deviceId);
			$device['path'] = '/';

            /* $module = "device";
			$groupDetails = $app->hubFunctions->getPermissionsType($serverId, $userId, $module, $deviceId, $userGroupDetails, $isAdmin, true);
			$device['uGroup'] = count($groupDetails['groups']); */
            $device['uGroup'] = 0;

			/* $permissions = $app->hubFunctions->userPermissions($serverId, $userId);
			$device['de'] = (isset($permissions["device_rights"]) && in_array("Edit Device", $permissions["device_rights"])) ? true : false; */
            $device['de'] = true;
		}
		else{
			$app->hubFunctions->echoResponse(array('status' => 'error', 'desc' => 'Not Found or deleted', 'code' => 4004));
		}
	}
	else{
		$device = array("code" => 1000, "status" => "error", "desc" => "invalid id");
	}
	$app->hubFunctions->echoResponse($device);
});

$app->post('/action/devices', function() use($app, $serverId, $userId, $isAdmin, $userData){
	_action_devices($app, $serverId, $userId, $isAdmin, false, $userData);
});

function _action_devices($app, $serverId, $userId, $isAdmin, $sInfo = false, $userData = array()){
    $request = (array) json_decode($app->request()->getBody(), true);

    $ids = $buttonsArr = $folderIds = $info = $isExistDvc = $dvcTypeArr = array();
    // $ids = array_column($request, "id");
    foreach($request as $valuee){
        $valuee["type"] = strtolower($valuee["type"]);
        if($valuee["type"] == 'folder'){
            $folderIds[] = $valuee['id'];
        }
        else if($valuee["type"] == 'device'){
            $ids[] = $valuee['id'];
        }
    }

	if(!empty($app->hubFunctions->userPermissionArr)){
		$permissions = $app->hubFunctions->userPermissionArr;
	}
	else{
		$permissions = $app->hubFunctions->userPermissions($serverId, $userId);
	}

    $idsArr = array_unique($ids);
    $idsArrLength = count($idsArr);
    $folderIdsArr = array_unique($folderIds);
    $folderIdsArrLength = count($folderIds);
    $totalCount = $folderIdsArrLength + $idsArrLength;

	/* if(!empty($idsArr)){
		$app->hubFunctions->validateItemAccess($serverId, $userId, 'device', $idsArr, $userData["userGroupDetails"], $isAdmin);
	}

	if(!empty($folderIdsArr)){
		$app->hubFunctions->validateItemAccess($serverId, $userId, 'devicefolder', $folderIdsArr, $userData["userGroupDetails"], $isAdmin);
	}

    $serverInfo = $app->hubFunctions->prepare_and_execute("SELECT devicegrouping FROM hubcp.server WHERE id = :serverId", array(':serverId' => $serverId))->fetch(PDO::FETCH_ASSOC); */

    if(!empty($idsArr)){
        $dvcIds = implode(',', $idsArr);
        $isExistDvc = $app->hubFunctions->query("select count(distinct fld.id) from flassignment as fl inner join fldeviceassociation as fld on fl.id = fld.assignmentid where fld.deviceid in ($dvcIds) and fl.isapproved = 1")->fetch(PDO::FETCH_ASSOC);
        $dvcTypeArr = $app->hubFunctions->query("select ARRAY_TO_STRING(ARRAY_AGG(DISTINCT devicetype), ',') AS dt from device where id in ($dvcIds)")->fetch(PDO::FETCH_ASSOC);
    }

    $isMcCase = $isEslCase = false;
    if(isset($permissions["device_rights"])){
        $info = array(
            "edit" => array("key" => "dEdit", "code" => 2005102, "desc" => "Edit Device"),
            "delete" => array("key" => "dDelete", "code" => 2005103, "desc" => "Delete Device"),
            "edittags" => array("key" => "tEdit", "code" => 2005108, "desc" => "Edit Tags"),
            "addtogroup" => array("key" => "dAddToGroup", "code" => 2005104, "desc" => "Add Device Group"),
            "preview" => array("key" => "dPreview", "code" => 2005130, "desc" => "Device Preview"),
            "editfolder" => array("key" => "dEditFolder", "code" => 2005132, "desc" => "Edit Folder"),
            "move" => array("key" => "dMove", "code" => 2005133, "desc" => "Move"),
            "deletefolder" => array("key" => "dDeleteFolder", "code" => 2005134, "desc" => "Delete Folder"),
        );
        if($totalCount > 1){
            unset($info["edit"], $info["editfolder"]);
        }
        if($idsArrLength > 1){
            unset($info["delete"]);
        }
        if($folderIdsArrLength > 0){
            unset($info["edittags"], $info["preview"]);
        }
        if(empty($folderIds)){
            unset($info["editfolder"]);
        }
        if(in_array("Move", $permissions["device_rights"])){
            unset($info["move"]);
        }

        if($idsArrLength == 1 && $totalCount == 1 && in_array("Edit Device", $permissions["device_rights"])){
            //$dvcType = $app->hubFunctions->getOne("device", array("devicetype"), array("id" => $idsArr));
            if(isset($permissions["frame_layout_rights"]) && (in_array("Edit assignment", $permissions["frame_layout_rights"]) || in_array("Assign", $permissions["frame_layout_rights"])) && isset($isExistDvc) && $isExistDvc["count"] == "0"){
                $stepsArr = array(
                    array(
                        "key" => "dStep1",
                        "label" => "Assign Name"
                    ),
                    array(
                        "key" => "dStep2",
                        "label" => "Assign Frame Layout"
                    ),
                    array(
                        "key" => "dStep3",
                        "label" => "Assign Tags"
                    )
                );

                $edit_tag = array(
                    array(
                        "key" => "tStep1",
                        "label" => "Assign Tags"
                    ),
                    array(
                        "key" => "tStep2",
                        "label" => "Remove Tags"
                    )
                );

                if(strtolower($dvcTypeArr["dt"]) == "mc" || strtolower($dvcTypeArr["dt"]) == EPD_LB){
                    $stepsArr = array(
                        array(
                            "key" => "dStep1",
                            "label" => "Assign Name"
                        ),
                        array(
                            "key" => "dStep3",
                            "label" => "Assign Tags"
                        )
                    );
                }
                $buttonsArr = array(
                    array(
                        "key" => "dEdit",
                        "label" => "Edit",
                        "steps" => $stepsArr
                    ),
                    array(
                        "key" => "dMove",
                        "label" => "Move"
                    ),
                    array(
                        "key" => "tEdit",
                        "label" => "Edit Tags",
                        "steps" => $edit_tag
                    ),
                    array(
                        "key" => "dAddToGroup",
                        "label" => "Add to Group"
                    ),
                    /* array(
                        "key" => "dSimilar",
                        "label" => "Similar"
                    ), */
                    array(
                        "key" => "dPreview",
                        "label" => "Preview"
                    ),
                    array(
                        "key" => "dDelete",
                        "label" => "Delete"
                    )
                );
            }
            else{
                $buttonsArr = array(
                    array(
                        "key" => "dEdit",
                        "label" => "Edit",
                        "steps" => array(
                            array(
                                "key" => "dStep1",
                                "label" => "Assign Name"
                            ),
                            array(
                                "key" => "dStep3",
                                "label" => "Assign Tags"
                            )
                        )
                    ),
                    array(
                        "key" => "dMove",
                        "label" => "Move"
                    ),
                    array(
                        "key" => "tEdit",
                        "label" => "Edit Tags",
                        "steps" => array(
                            array(
                                "key" => "tStep1",
                                "label" => "Assign Tags"
                            ),
                            array(
                                "key" => "tStep2",
                                "label" => "Remove Tags"
                            )
                        )
                    ),
                    array(
                        "key" => "dAddToGroup",
                        "label" => "Add to Group"
                    ),
                    /* array(
                        "key" => "dSimilar",
                        "label" => "Similar"
                    ), */
                    array(
                        "key" => "dPreview",
                        "label" => "Preview"
                    ),
                    array(
                        "key" => "dDelete",
                        "label" => "Delete"
                    )
                );
            }
        }
        else if($folderIdsArrLength == 1 && $totalCount == 1){
            $buttonsArr = array(
                array(
                    "key" => "dOpenFolder",
                    "label" => "Open Folder"
                ),
                array(
                    "key" => "dEditFolder",
                    "label" => "Edit Folder"
                ),
                array(
                    "key" => "dMove",
                    "label" => "Move"
                ),
                array(
                    "key" => "dAddToGroup",
                    "label" => "Add to Group"
                ),
                array(
                    "key" => "dDeleteFolder",
                    "label" => "Delete Folder"
                )
            );

            /* if(in_array("Edit Folder", $permissions["device_rights"])){
                array_splice($buttonsArr, 2, 0, array(array("key" => "dEditFolder", "label" => "Edit Folder")));
            } */
        }
        else{
            if($idsArrLength > 1  && empty($folderIdsArrLength)){
                $isAddToGroup = false;
                $explode_notice = explode(",", strtolower($dvcTypeArr["dt"]));
                if(in_array("mc", $explode_notice) || in_array(EPD_LB, $explode_notice)){
                    if(strtolower($dvcTypeArr["dt"]) == "mc" || strtolower($dvcTypeArr["dt"]) == EPD_LB){
                        $isAddToGroup = true;
                        //$buttonsArr = array(array("key" => "dAddToGroup", "label" => "Add to Group"), array("key" => "dDelete", "label" => "Delete"));
                    }
                    else{
                        $isMcCase = true;
                        $isEslCase = true;
                        $info["addtogroup"] = array("key" => "dAddToGroup", "code" => 2005112, "desc" => "Selected devices contain music type device therefore you can not addtogroup");

                        $info["edittags"] = array("key" => "editTags", "code" => 2005131, "desc" => "Selected devices contain music type device therefore you can not edit tag");
                        // $buttonsArr = array(array("key" => "dDelete", "label" => "Delete"));
                    }
                }
                else{
                    $isAddToGroup = true;
                    //$buttonsArr = array(array("key" => "dAddToGroup", "label" => "Add to Group"), array("key" => "dDelete", "label" => "Delete"));
                }

                if($isAddToGroup){
                    // $buttonsArr = array(array("key" => "dAddToGroup", "label" => "Add to Group"), array("key" => "dDelete", "label" => "Delete"));
                    $buttonsArr = array(
                        array(
                            "key" => "dMove",
                            "label" => "Move"
                        ),
                        array(
                            "key" => "tEdit",
                            "label" => "Edit Tags",
                            "steps" => array(
                                array(
                                    "key" => "tStep1",
                                    "label" => "Assign Tags"
                                ),
                                array(
                                    "key" => "tStep2",
                                    "label" => "Remove Tags"
                                )
                            )
                        ),
                        array(
                            "key" => "dAddToGroup",
                            "label" => "Add to Group"
                        )
                    );
                }

                $info["delete"] = array("key" => "dDelete", "code" => 2005113, "desc" => "Multiple devices can not be deleted at once.");
            }
            else if($folderIdsArrLength > 1 && $idsArrLength < 1){
                $buttonsArr = array(
                    array(
                        "key" => "dMove",
                        "label" => "Move"
                    ),
                    array(
                        "key" => "dAddToGroup",
                        "label" => "Add to Group"
                    ),
                    array(
                        "key" => "dDeleteFolder",
                        "label" => "Delete Folder"
                    )
                );
            }
            else if($folderIdsArrLength == 0){
                $buttonsArr = array(
                    array("key" => "dEdit", "label" => "Edit"),
                    array("key" => "tEdit", "label" => "Edit tag"),
                    array("key" => "dMove", "label" => "Move"),
                    array("key" => "dAddToGroup", "label" => "Add to Group"),
                    /*array("key" => "dSimilar", "label" => "Similar"),*/
                    array("key" => "dPreview", "label" => "Preview"),
                    array("key" => "dDelete", "label" => "Delete")
                );
            }
            else if($idsArrLength <= 1 && $folderIdsArrLength >= 1){ // {0,1} {1,1} {0,n} {1,n}
                    $buttonsArr = array(
                        array("key" => "dMove", "label" => "Move"),
                        array("key" => "dAddToGroup", "label" => "Add to Group"),
                    );
                    if(in_array("Delete Device", $permissions["device_rights"]) && in_array("Delete Folder", $permissions["device_rights"])){
                        $btnArr = array("key" => "dDelete", "label" => "Delete");
                        array_push($buttonsArr,$btnArr);
                    }
            }
            else{
                $buttonsArr = array(
                    array("key" => "dMove", "label" => "Move"),
                    array("key" => "dAddToGroup", "label" => "Add to Group")
                );
            }
            /*if($idsArrLength > 1 && in_array("Edit Device", $permissions["device_rights"])){
                unset($info["edit"], $info["similar"], $info["preview"], $info["dAddToGroup"]);
            }*/
        }

        // When dashboard pin items is disabled from user preferences, pin button should be display in devices module, and if any device is pinned then unpin button should be display.
        if(!empty($userData['dashboard']['udashboarddetail'])){
            $uDashEnable = json_decode($userData['dashboard']['udashboarddetail'], true);
            if(!empty($uDashEnable['dpi'])){
                if(!empty($_GET['pin'])){
                    $buttonsArr[] = array("key" => "dUnPin", "label" => "UnPin Item");
                }
                else{
                    $buttonsArr[] = array("key" => "dPin", "label" => "Pin Item");
                }
            }
        }

        if(!empty($buttonsArr)){
            // now chk $buttonsArr for Device Preview permission, and filter it //
            if(!in_array("Device Preview", $permissions["device_rights"]) && in_array("dPreview", array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dPreview"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else{
                unset($info["preview"]);
            }

            // now chk $buttonsArr for permission, and filter it //
            if( ( !in_array("Edit Group", $permissions["device_rights"])) && in_array("dAddToGroup",  array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dAddToGroup"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else{
                if(!$isMcCase || !$isEslCase){
                    unset($info["addtogroup"]);
                }
            }

            // if(!in_array("Edit Device", $permissions["device_rights"]) && in_array("tEdit", array_column($buttonsArr, "key"))){
            if( (!in_array("Edit tag", $permissions["device_rights"]) || !in_array("Edit Device", $permissions["device_rights"]) ) && in_array("tEdit", array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "tEdit"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else{
                if(!$isMcCase || !$isEslCase){
                    unset($info["edittags"]);
                }
            }

            if(!in_array("Edit Device", $permissions["device_rights"]) && in_array("dEdit", array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dEdit"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else{
                if(!$isMcCase || !$isEslCase){
                    unset($info["edit"]);
                }
            }

            //check if devicetype = mc we will remove dSimilar
            if($idsArrLength == 1 && (strtolower($dvcTypeArr["dt"]) == "mc" || strtolower($dvcTypeArr["dt"]) == EPD_LB) ){
                foreach($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dPreview"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
                $isMcCase = true;
                $isEslCase = true;
                $tmp_cd = (strtolower($dvcTypeArr["dt"]) == "mc") ? 2001123 : 2001124;
                $info["preview"] = array("key" => "dPreview", "code" => $tmp_cd, "desc" => "Preview button can not show because selected device is ".$dvcTypeArr["dt"]." type");
            }

            if((!in_array("Delete Device", $permissions["device_rights"])) && in_array("dDelete", array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dDelete"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else if($idsArrLength == 1 || $folderIdsArrLength > 0){ // 2005113
                unset($info["delete"]);
            }

            // now chk $buttonsArr for permission, and filter it //
            if(!in_array("Move", $permissions["device_rights"]) && in_array("dMove", array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dMove"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else{
                if(!$isMcCase || !$isEslCase){
                    unset($info["move"]);
                }
            }

            if(!in_array("Edit Folder", $permissions["device_rights"]) && in_array("dEditFolder", array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dEditFolder"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else{
                unset($info["editfolder"]);
            }

            if(!in_array("Delete Folder", $permissions["device_rights"]) && in_array("dDeleteFolder", array_column($buttonsArr, "key"))){
                foreach ($buttonsArr as $thisArrIndex => $subArray){
                    if($subArray["key"] == "dDeleteFolder"){
                        unset($buttonsArr[$thisArrIndex]);
                    }
                }
                $buttonsArr = array_values($buttonsArr);
            }
            else{
                unset($info["deletefolder"]);
            }

            if($idsArrLength <= 1 && $folderIdsArrLength >= 1){
                if((!in_array("Delete Device", $permissions["device_rights"]) && in_array("Delete Folder", $permissions["device_rights"])) ){
                    $info["delete"] = array("key" => "dDelete", "code" => 2005103, "desc" => "Delete Device");
                    unset($info["deletefolder"]);
                }
                if((in_array("Delete Device", $permissions["device_rights"]) && !in_array("Delete Folder", $permissions["device_rights"])) ){
                    $info["deletefolder"] = array("key" => "dDeleteFolder", "code" => 2005134, "desc" => "Delete Folder");
                    unset($info["delete"]);
                }
                if((!in_array("Delete Device", $permissions["device_rights"]) && !in_array("Delete Folder", $permissions["device_rights"])) ){
                    $info["delete"] = array("key" => "dDelete", "code" => 2005103, "desc" => "Delete Device");
                    $info["deletefolder"] = array("key" => "dDeleteFolder", "code" => 2005134, "desc" => "Delete Folder");

                }
                if($idsArrLength < 1 && $folderIdsArrLength >= 1){
                    unset($info["delete"]);
                }
            }
        }
    }

    $info = ($isAdmin && (!$isMcCase || !$isEslCase) && $idsArrLength == 1) ? array() : array_values($info);

    $data = array("info" => $info, "buttons" => $buttonsArr);
	$app->hubFunctions->echoResponse($data);
}

$app->run();

