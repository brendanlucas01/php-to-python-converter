--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5
-- Dumped by pg_dump version 12.5

-- Started on 2025-10-09 20:44:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- CREATE SCHEMA public;


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 247378)
-- Name: contentlibrary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contentlibrary (
    id integer NOT NULL,
    label character varying(1024),
    src character varying(1024),
    createdon timestamp without time zone,
    createdby integer,
    isapproved integer DEFAULT 0,
    approvedon timestamp without time zone,
    approvedby integer,
    type integer,
    folderid integer,
    restorefolderid integer,
    size numeric(20,2),
    width integer,
    height integer,
    extension character varying(20),
    duration numeric(20,2),
    status integer DEFAULT 0,
    archivedon timestamp without time zone,
    deletedon timestamp without time zone,
    editedon timestamp without time zone,
    editedby integer,
    iscompleted integer DEFAULT 1,
    optimizevideo integer DEFAULT 1,
    detail text,
    expireon timestamp without time zone,
    serverid integer,
    activefrom timestamp without time zone,
    activeto timestamp without time zone,
    oncecompleted smallint DEFAULT 0,
    processedsize bigint,
    settings text,
    isscene smallint DEFAULT (0)::smallint,
    uploadgroupid character varying(1024) DEFAULT 0,
    issensitivitychk integer DEFAULT 0,
    mailsent integer DEFAULT 0,
    isblur integer DEFAULT 0,
    issensitivitychkforcopy integer DEFAULT 0,
    uploadsource smallint DEFAULT 0,
    asanaattachid bigint DEFAULT 0
);


--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN contentlibrary.size; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.contentlibrary.size IS 'kilo bytes';


--
-- TOC entry 3133 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN contentlibrary.detail; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.contentlibrary.detail IS 'will having json data';


--
-- TOC entry 3134 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN contentlibrary.oncecompleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.contentlibrary.oncecompleted IS 'This column mainly using for template and approval state 0 = item is still uncomplete by process 1 = item has been completed once';


--
-- TOC entry 3135 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN contentlibrary.processedsize; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.contentlibrary.processedsize IS 'bytes';


--
-- TOC entry 3136 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN contentlibrary.uploadgroupid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.contentlibrary.uploadgroupid IS 'Store unique id in this column when upload multiple contents';


--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN contentlibrary.uploadsource; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.contentlibrary.uploadsource IS 'This column is mainly used to differentiate the content upload source:0 = Hub (default), 1 = Canva, 2 = PowerPoint Plugin.';


--
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN contentlibrary.asanaattachid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.contentlibrary.asanaattachid IS 'Used to store attachment id (gid) of attachment (Asana Task''s + Schedule = attachment)';


--
-- TOC entry 203 (class 1259 OID 247397)
-- Name: contentlibrary_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contentlibrary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3139 (class 0 OID 0)
-- Dependencies: 203
-- Name: contentlibrary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contentlibrary_id_seq OWNED BY public.contentlibrary.id;


--
-- TOC entry 204 (class 1259 OID 247399)
-- Name: contentpermission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contentpermission (
    id integer NOT NULL,
    contentid integer,
    usergroupid integer
);


--
-- TOC entry 205 (class 1259 OID 247402)
-- Name: contentpermission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contentpermission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3140 (class 0 OID 0)
-- Dependencies: 205
-- Name: contentpermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contentpermission_id_seq OWNED BY public.contentpermission.id;


--
-- TOC entry 206 (class 1259 OID 247404)
-- Name: device; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device (
    id integer NOT NULL,
    name character varying(100),
    hardwareid character varying(50),
    os integer DEFAULT 1,
    publicip character varying(50),
    localip character varying(50),
    slideversion character varying(50),
    watcherversion character varying(50),
    resolution character varying(50),
    connectionstatus timestamp without time zone,
    createdon timestamp without time zone,
    createdby integer,
    timezone character varying(100),
    updateversion integer,
    isactive integer,
    autoupdate integer,
    offlinereboot integer,
    lastxmlgeneratedon timestamp without time zone,
    thumbversion integer DEFAULT 0,
    serverid integer,
    space integer,
    localdatetime character varying(20),
    devicetype character varying(20) DEFAULT 'mp'::character varying,
    lanaccessible boolean,
    computername character varying(100),
    guid character varying(100),
    tzname character varying(100),
    scheduledsize bigint DEFAULT 0,
    resourcesize integer DEFAULT 0,
    woeid integer DEFAULT 6167865,
    updateversion_em integer DEFAULT 0,
    displaytime_em timestamp without time zone,
    raw_time_on_device character varying(50),
    time_on_device timestamp without time zone,
    notifiedon timestamp without time zone,
    info text DEFAULT '[]'::text,
    emptyfeed_notifiedon timestamp without time zone,
    client integer DEFAULT 0,
    isticket integer DEFAULT 0 NOT NULL,
    eslinfo text,
    migratedon timestamp without time zone,
    notifiedon_bigpanda timestamp without time zone,
    firsttimemigrate character varying DEFAULT 's'::character varying,
    cc text,
    firstconnected timestamp without time zone,
    notifiedon_hubspot timestamp without time zone,
    folderid integer DEFAULT 0,
    report_settings integer DEFAULT 0
)
WITH (autovacuum_vacuum_scale_factor='0.1', autovacuum_vacuum_threshold='10');


--
-- TOC entry 3141 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.notifiedon; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.notifiedon IS 'Used in offlineDeviceNotify';


--
-- TOC entry 3142 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.emptyfeed_notifiedon; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.emptyfeed_notifiedon IS 'Used in deviceEmptyFeedNotify';


--
-- TOC entry 3143 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.isticket; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.isticket IS 'This is the column to identify, if there are any tickets of supportdesk are associated with this device, if its value is 0, then no tickets associated, if its value is non-zero then there are some tickets associated, the non-zero value stored in this column is the id of server table at supportdesk';


--
-- TOC entry 3144 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.notifiedon_bigpanda; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.notifiedon_bigpanda IS 'Used in offlineDeviceNotify (bigpanda)';


--
-- TOC entry 3145 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.firsttimemigrate; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.firsttimemigrate IS 's = Device not migrated, r = device migrated';


--
-- TOC entry 3146 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.cc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.cc IS 'Used to store data of confirmed (downloaded) content on the device, previously we used to store in "devicesetting>details>confirmedContent". After 16 April 2025, we created new table device_cc to store this data.';


--
-- TOC entry 3147 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.firstconnected; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.firstconnected IS 'Column is used to store the datetime of when device come online first time';


--
-- TOC entry 3148 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.notifiedon_hubspot; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.notifiedon_hubspot IS 'Used in offlineDeviceNotify (HubSpot)';


--
-- TOC entry 3149 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN device.report_settings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device.report_settings IS 'If reports enabled on server then we''ll check this column before fixing value of "reports" attrib in "device" node of getfeeds3';


--
-- TOC entry 207 (class 1259 OID 247423)
-- Name: device_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3150 (class 0 OID 0)
-- Dependencies: 207
-- Name: device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_id_seq OWNED BY public.device.id;


--
-- TOC entry 208 (class 1259 OID 247425)
-- Name: deviceextraips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deviceextraips (
    id integer NOT NULL,
    deviceid integer,
    hardwareid character varying(50),
    name character varying(50),
    description character varying(250)
);


--
-- TOC entry 209 (class 1259 OID 247428)
-- Name: deviceextraips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deviceextraips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3151 (class 0 OID 0)
-- Dependencies: 209
-- Name: deviceextraips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deviceextraips_id_seq OWNED BY public.deviceextraips.id;


--
-- TOC entry 238 (class 1259 OID 247640)
-- Name: devicemigrationhistory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devicemigrationhistory (
    id integer NOT NULL,
    deviceid integer,
    fromhardwareid character varying(100),
    tohardwareid character varying(100),
    migratedon timestamp without time zone,
    migratedby integer,
    reason integer
);


--
-- TOC entry 3152 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN devicemigrationhistory.reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devicemigrationhistory.reason IS '1=TV/Media Player changed,2=NIC changed';


--
-- TOC entry 239 (class 1259 OID 247643)
-- Name: devicemigrationhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devicemigrationhistory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3153 (class 0 OID 0)
-- Dependencies: 239
-- Name: devicemigrationhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devicemigrationhistory_id_seq OWNED BY public.devicemigrationhistory.id;


--
-- TOC entry 241 (class 1259 OID 247670)
-- Name: devicepermission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devicepermission (
    id integer NOT NULL,
    deviceid integer,
    usergroupid integer
);


--
-- TOC entry 240 (class 1259 OID 247668)
-- Name: devicepermission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devicepermission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3154 (class 0 OID 0)
-- Dependencies: 240
-- Name: devicepermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devicepermission_id_seq OWNED BY public.devicepermission.id;


--
-- TOC entry 210 (class 1259 OID 247430)
-- Name: deviceproperties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deviceproperties (
    id integer NOT NULL,
    label character varying(100),
    val character varying(500),
    createdon timestamp without time zone,
    createdby integer,
    serverid integer,
    sort integer,
    descriptions text,
    vtype character varying(100) DEFAULT 't'::character varying
);


--
-- TOC entry 211 (class 1259 OID 247437)
-- Name: deviceproperties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deviceproperties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3155 (class 0 OID 0)
-- Dependencies: 211
-- Name: deviceproperties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deviceproperties_id_seq OWNED BY public.deviceproperties.id;


--
-- TOC entry 212 (class 1259 OID 247439)
-- Name: devicepropertiesassociation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devicepropertiesassociation (
    id integer NOT NULL,
    dpid integer,
    deviceid integer,
    val character varying(500),
    vtype character varying(100) DEFAULT 't'::character varying
);


--
-- TOC entry 213 (class 1259 OID 247446)
-- Name: devicepropertiesassociation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devicepropertiesassociation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3156 (class 0 OID 0)
-- Dependencies: 213
-- Name: devicepropertiesassociation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devicepropertiesassociation_id_seq OWNED BY public.devicepropertiesassociation.id;


--
-- TOC entry 214 (class 1259 OID 247448)
-- Name: devicesetting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devicesetting (
    id integer NOT NULL,
    deviceid integer,
    screenshotcapture integer,
    screenshotinterval integer,
    datathreshold integer,
    warningdatalimit numeric(4,3),
    terminatedatalimit numeric(4,3),
    warningemail character varying(250),
    warningmailsent integer,
    feedrestriction integer DEFAULT 0,
    feedrestrictionstarton timestamp without time zone,
    feedrestrictionendon timestamp without time zone,
    overridedownloadsize double precision DEFAULT 0,
    polling integer DEFAULT 30,
    desktopdisplaymodes text,
    desktoprefreshrate smallint,
    desktopcolordepth smallint,
    requesteddisplaymode character varying(200),
    displaymoderequestedon integer,
    displaymodeacknowledgedon integer,
    screenshotstatus smallint DEFAULT 0,
    detail text
);


--
-- TOC entry 3157 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN devicesetting.screenshotinterval; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devicesetting.screenshotinterval IS 'in seconds';


--
-- TOC entry 3158 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN devicesetting.polling; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devicesetting.polling IS 'polling is use for set time in seconds to fetching the data from slide';


--
-- TOC entry 215 (class 1259 OID 247458)
-- Name: devicesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devicesetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3159 (class 0 OID 0)
-- Dependencies: 215
-- Name: devicesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devicesetting_id_seq OWNED BY public.devicesetting.id;


--
-- TOC entry 216 (class 1259 OID 247460)
-- Name: devicetag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devicetag (
    id integer NOT NULL,
    name character varying(260),
    createdon timestamp without time zone,
    createdby integer,
    serverid integer,
    color character varying(1024),
    detail text
);


--
-- TOC entry 217 (class 1259 OID 247466)
-- Name: devicetag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devicetag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3160 (class 0 OID 0)
-- Dependencies: 217
-- Name: devicetag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devicetag_id_seq OWNED BY public.devicetag.id;


--
-- TOC entry 218 (class 1259 OID 247468)
-- Name: devicetagassociation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devicetagassociation (
    id integer NOT NULL,
    deviceid integer,
    tagid integer
);


--
-- TOC entry 219 (class 1259 OID 247471)
-- Name: devicetagassociation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devicetagassociation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3161 (class 0 OID 0)
-- Dependencies: 219
-- Name: devicetagassociation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devicetagassociation_id_seq OWNED BY public.devicetagassociation.id;


--
-- TOC entry 220 (class 1259 OID 247473)
-- Name: flassignment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flassignment (
    id integer NOT NULL,
    name character varying(255),
    layoutid integer,
    createdon timestamp without time zone,
    createdby integer,
    approvedon timestamp without time zone,
    approvedby integer,
    editedon timestamp without time zone,
    editedby integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    iscustom integer,
    isapproved integer,
    isconflict integer DEFAULT 0,
    isforever integer DEFAULT 0
);


--
-- TOC entry 3162 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN flassignment.isforever; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.flassignment.isforever IS '0=date range selected. 1=date is setup for 100 years (forever)';


--
-- TOC entry 221 (class 1259 OID 247478)
-- Name: flassignment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flassignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3163 (class 0 OID 0)
-- Dependencies: 221
-- Name: flassignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flassignment_id_seq OWNED BY public.flassignment.id;


--
-- TOC entry 222 (class 1259 OID 247480)
-- Name: fldeviceassociation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fldeviceassociation (
    id integer NOT NULL,
    assignmentid integer,
    deviceid integer,
    devicegroupid integer,
    assignedvia character varying(250)
);


--
-- TOC entry 3164 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN fldeviceassociation.assignedvia; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.fldeviceassociation.assignedvia IS 'DEFAULT 0, -- if 1 or 3 , 1= framelayout , 3= framelayoutlibrary and 2 is for framelayoutassignment';


--
-- TOC entry 223 (class 1259 OID 247483)
-- Name: fldeviceassociation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fldeviceassociation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3165 (class 0 OID 0)
-- Dependencies: 223
-- Name: fldeviceassociation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fldeviceassociation_id_seq OWNED BY public.fldeviceassociation.id;


--
-- TOC entry 224 (class 1259 OID 247485)
-- Name: framelayout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.framelayout (
    id integer NOT NULL,
    name character varying(255),
    createdon timestamp without time zone,
    createdby integer,
    approvedon timestamp without time zone,
    approvedby integer,
    editedon timestamp without time zone,
    editedby integer,
    width integer,
    height integer,
    isapproved integer,
    bgcolor character varying(10),
    serverid integer,
    orientation character varying(50),
    thumbversion integer DEFAULT 0,
    oncecompleted smallint DEFAULT 0,
    layoutbgtype character varying(20) DEFAULT 'monochrome'::character varying,
    defaultframeid integer DEFAULT 0
);


--
-- TOC entry 3166 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN framelayout.oncecompleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.framelayout.oncecompleted IS 'This column mainly using for framelayout and approval state 0 = item is still uncomplete by process 1 = item has been completed once';


--
-- TOC entry 225 (class 1259 OID 247492)
-- Name: framelayout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.framelayout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3167 (class 0 OID 0)
-- Dependencies: 225
-- Name: framelayout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.framelayout_id_seq OWNED BY public.framelayout.id;


--
-- TOC entry 226 (class 1259 OID 247494)
-- Name: schedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule (
    id integer NOT NULL,
    name character varying(100),
    createdon timestamp without time zone,
    createdby integer,
    approvedon timestamp without time zone,
    approvedby integer,
    editedon timestamp without time zone,
    editedby integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    iscustom integer DEFAULT 0,
    isapproved integer DEFAULT 0,
    isactive integer DEFAULT 0,
    iscompleted integer DEFAULT 0,
    schedulegroupid integer DEFAULT 0,
    serverid integer,
    oncecompleted smallint DEFAULT 0,
    isconflict integer DEFAULT 0,
    isforever integer DEFAULT 0,
    priority integer DEFAULT 1,
    istrainingmode smallint DEFAULT 0,
    type integer DEFAULT 0,
    detail text,
    asanataskchangeon timestamp without time zone,
    asanaattachid bigint DEFAULT 0,
    asanataskid bigint DEFAULT 0
);


--
-- TOC entry 3168 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN schedule.oncecompleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedule.oncecompleted IS '0 = schedule is in process, 1 = schedule is completed once.';


--
-- TOC entry 3169 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN schedule.isforever; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedule.isforever IS '0=date range selected. 1=date is setup for 100 years (forever)';


--
-- TOC entry 3170 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN schedule.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedule.type IS '0=normal,1=lockscreen,2=corp_comm,3=EPD,4=content_demand';


--
-- TOC entry 3171 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN schedule.asanataskchangeon; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedule.asanataskchangeon IS 'Used to store last detected change (from webhook) on the task';


--
-- TOC entry 227 (class 1259 OID 247513)
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3172 (class 0 OID 0)
-- Dependencies: 227
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- TOC entry 228 (class 1259 OID 247515)
-- Name: schedulecontentassociation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedulecontentassociation (
    id integer NOT NULL,
    scheduleid integer,
    contentid integer,
    duration numeric(20,2),
    sortorder integer,
    fullscreen integer,
    sound integer,
    typ character varying(50) DEFAULT 'content'::character varying,
    userid integer,
    scaling character varying(10) DEFAULT 'crop'::character varying,
    caption integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 3173 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN schedulecontentassociation.scaling; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedulecontentassociation.scaling IS '"fit/crop/skew" - based on user selection while scheduling';


--
-- TOC entry 3174 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN schedulecontentassociation.caption; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedulecontentassociation.caption IS 'used to store the languageId of caption of video';


--
-- TOC entry 229 (class 1259 OID 247521)
-- Name: schedulecontentassociation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedulecontentassociation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3175 (class 0 OID 0)
-- Dependencies: 229
-- Name: schedulecontentassociation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedulecontentassociation_id_seq OWNED BY public.schedulecontentassociation.id;


--
-- TOC entry 230 (class 1259 OID 247523)
-- Name: scheduledeviceassociation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheduledeviceassociation (
    scheduleid integer,
    deviceid integer,
    devicegroupid integer,
    sortorder integer,
    tagid integer DEFAULT 0,
    frameid integer,
    layoutid integer,
    assignmentids text,
    searchid integer DEFAULT 0,
    dvwid integer,
    id integer NOT NULL
);


--
-- TOC entry 3176 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN scheduledeviceassociation.dvwid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduledeviceassociation.dvwid IS 'id of device video wall';


--
-- TOC entry 231 (class 1259 OID 247531)
-- Name: scheduledeviceassociation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheduledeviceassociation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3177 (class 0 OID 0)
-- Dependencies: 231
-- Name: scheduledeviceassociation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheduledeviceassociation_id_seq OWNED BY public.scheduledeviceassociation.id;


--
-- TOC entry 232 (class 1259 OID 247533)
-- Name: schedulepermission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedulepermission (
    id integer NOT NULL,
    scheduleid integer,
    usergroupid integer
);


--
-- TOC entry 233 (class 1259 OID 247536)
-- Name: schedulepermission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedulepermission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3178 (class 0 OID 0)
-- Dependencies: 233
-- Name: schedulepermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedulepermission_id_seq OWNED BY public.schedulepermission.id;


--
-- TOC entry 236 (class 1259 OID 247632)
-- Name: timezone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timezone (
    id integer NOT NULL,
    label character varying(100),
    timezone character varying(100),
    "offset" numeric(4,2),
    name character varying(100)
);


--
-- TOC entry 237 (class 1259 OID 247635)
-- Name: timezone_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timezone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3179 (class 0 OID 0)
-- Dependencies: 237
-- Name: timezone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timezone_id_seq OWNED BY public.timezone.id;


--
-- TOC entry 234 (class 1259 OID 247538)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    fname character varying(100),
    lname character varying(100),
    dp character varying(260),
    email character varying(260),
    pwd character varying(250),
    createdon timestamp without time zone,
    createdby integer,
    isverified integer,
    istourvisited integer,
    timezone character varying(100),
    lang character varying(10),
    code character varying(10),
    islpopen integer DEFAULT 1,
    istreeopen integer DEFAULT 1,
    issplitv integer DEFAULT 0,
    ispin integer DEFAULT 0,
    ispopup integer DEFAULT 1,
    deviceview character varying(20) DEFAULT 'l'::character varying,
    contentdisplaysize character varying(50) DEFAULT 'n'::character varying,
    issuperadmin integer,
    isactive integer,
    isapproved integer,
    partnerid integer,
    changepwd integer DEFAULT 0 NOT NULL,
    ispwdlinkactive integer DEFAULT 0,
    mobileno character varying(20),
    deviceid text,
    devicearn text,
    ishubuser integer DEFAULT 0,
    iscpuser integer DEFAULT 0,
    ip character varying(250),
    userdetail text,
    login_attempts smallint DEFAULT 0,
    islocked smallint DEFAULT 0,
    login_wrong_attempt_time timestamp without time zone,
    resetpwd_key character varying(250),
    is2faactive smallint DEFAULT 0,
    "2fasecret" character varying(200),
    isoktauser smallint DEFAULT 0,
    content_scaling_schedule character varying(10) DEFAULT 'fit'::character varying,
    sctype integer DEFAULT '-1'::integer,
    schedule_default_date_range character varying(5) DEFAULT 'y'::character varying,
    dmbsort character varying(5) DEFAULT 'd'::character varying,
    theme character varying(20) DEFAULT 'df'::character varying,
    contentview character varying(20) DEFAULT 't'::character varying,
    isdf_treeopen integer DEFAULT 0,
    sfdl integer DEFAULT 1,
    sfop integer DEFAULT 1,
    templateview character varying(20) DEFAULT 't'::character varying,
    sdtf integer DEFAULT 0,
    dmb_templateview character varying(5) DEFAULT 'l'::character varying NOT NULL,
    dmb_deviceview character varying(5) DEFAULT 'l'::character varying NOT NULL,
    dmb_theme character varying(5) DEFAULT 'df'::character varying NOT NULL
);


--
-- TOC entry 3180 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".islpopen; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".islpopen IS 'isLpOpen decides weather user wants to open screen side bar open or collapsed.';


--
-- TOC entry 3181 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".istreeopen; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".istreeopen IS 'isTreeOpen decides to fix the position of the tree in content library module';


--
-- TOC entry 3182 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".issplitv; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".issplitv IS 'isSplitv decides weather user wants to split screen vertically for item selection';


--
-- TOC entry 3183 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".ispin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".ispin IS 'isPin decides to fix the position of the detail panel';


--
-- TOC entry 3184 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".ispopup; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".ispopup IS 'isPopup decides to having pop up for ui.';


--
-- TOC entry 3185 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".deviceview; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".deviceview IS 't="template", l = "list" for devlist list view';


--
-- TOC entry 3186 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".mobileno; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".mobileno IS 'To send sms notification';


--
-- TOC entry 3187 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".deviceid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".deviceid IS 'To get deviceARN FROM AWS SNS';


--
-- TOC entry 3188 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".devicearn; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".devicearn IS 'To send push notification';


--
-- TOC entry 3189 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".login_attempts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".login_attempts IS 'allowing user to attempt login on portal, default we are keeping 5';


--
-- TOC entry 3190 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".islocked; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".islocked IS 'will manage locking of user because of the lots of unsuccessfull attempt';


--
-- TOC entry 3191 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".is2faactive; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".is2faactive IS 'To check whether user has enabled 2FactorAuthentication';


--
-- TOC entry 3192 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user"."2fasecret"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user"."2fasecret" IS 'To store secret key of 2fa QR code';


--
-- TOC entry 3193 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".isoktauser; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".isoktauser IS 'used for SSO provided by OKTA';


--
-- TOC entry 3194 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".content_scaling_schedule; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".content_scaling_schedule IS '"fit/crop/skew" - To decide scaling of content while selecting them in scheduling process';


--
-- TOC entry 3195 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".sctype; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".sctype IS 'normal user = -1, support = 0, supportcoordinator = 1, salessupportcoordinator = 2';


--
-- TOC entry 3196 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".schedule_default_date_range; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".schedule_default_date_range IS 'y = 1 year, m = 1 month, w = 1 week';


--
-- TOC entry 3197 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".dmbsort; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".dmbsort IS 'd/a default will be d';


--
-- TOC entry 3198 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".theme; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".theme IS 'df=default,dk=dark';


--
-- TOC entry 3199 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".contentview; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".contentview IS 't = "Thumb view", l = "List view"';


--
-- TOC entry 3200 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".sfdl; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".sfdl IS 'sfdl = Show folders in device list in Device tab';


--
-- TOC entry 3201 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".sfop; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".sfop IS 'sfop = Show folders in device list in other places';


--
-- TOC entry 3202 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".templateview; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".templateview IS 't = "Thumb view", l = "List view"';


--
-- TOC entry 3203 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".dmb_templateview; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".dmb_templateview IS 'Menu Board - Template view (thumb / list)';


--
-- TOC entry 3204 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".dmb_deviceview; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".dmb_deviceview IS 'Menu Board - Device view (thumb / list)';


--
-- TOC entry 3205 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "user".dmb_theme; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public."user".dmb_theme IS 'Menu Board - Theme';


--
-- TOC entry 235 (class 1259 OID 247573)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3206 (class 0 OID 0)
-- Dependencies: 235
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 2823 (class 2604 OID 247575)
-- Name: contentlibrary id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentlibrary ALTER COLUMN id SET DEFAULT nextval('public.contentlibrary_id_seq'::regclass);


--
-- TOC entry 2824 (class 2604 OID 247576)
-- Name: contentpermission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentpermission ALTER COLUMN id SET DEFAULT nextval('public.contentpermission_id_seq'::regclass);


--
-- TOC entry 2838 (class 2604 OID 247577)
-- Name: device id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device ALTER COLUMN id SET DEFAULT nextval('public.device_id_seq'::regclass);


--
-- TOC entry 2839 (class 2604 OID 247578)
-- Name: deviceextraips id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deviceextraips ALTER COLUMN id SET DEFAULT nextval('public.deviceextraips_id_seq'::regclass);


--
-- TOC entry 2913 (class 2604 OID 247645)
-- Name: devicemigrationhistory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicemigrationhistory ALTER COLUMN id SET DEFAULT nextval('public.devicemigrationhistory_id_seq'::regclass);


--
-- TOC entry 2914 (class 2604 OID 247673)
-- Name: devicepermission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicepermission ALTER COLUMN id SET DEFAULT nextval('public.devicepermission_id_seq'::regclass);


--
-- TOC entry 2841 (class 2604 OID 247579)
-- Name: deviceproperties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deviceproperties ALTER COLUMN id SET DEFAULT nextval('public.deviceproperties_id_seq'::regclass);


--
-- TOC entry 2843 (class 2604 OID 247580)
-- Name: devicepropertiesassociation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicepropertiesassociation ALTER COLUMN id SET DEFAULT nextval('public.devicepropertiesassociation_id_seq'::regclass);


--
-- TOC entry 2848 (class 2604 OID 247581)
-- Name: devicesetting id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicesetting ALTER COLUMN id SET DEFAULT nextval('public.devicesetting_id_seq'::regclass);


--
-- TOC entry 2849 (class 2604 OID 247582)
-- Name: devicetag id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicetag ALTER COLUMN id SET DEFAULT nextval('public.devicetag_id_seq'::regclass);


--
-- TOC entry 2850 (class 2604 OID 247583)
-- Name: devicetagassociation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicetagassociation ALTER COLUMN id SET DEFAULT nextval('public.devicetagassociation_id_seq'::regclass);


--
-- TOC entry 2853 (class 2604 OID 247584)
-- Name: flassignment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flassignment ALTER COLUMN id SET DEFAULT nextval('public.flassignment_id_seq'::regclass);


--
-- TOC entry 2854 (class 2604 OID 247585)
-- Name: fldeviceassociation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fldeviceassociation ALTER COLUMN id SET DEFAULT nextval('public.fldeviceassociation_id_seq'::regclass);


--
-- TOC entry 2859 (class 2604 OID 247586)
-- Name: framelayout id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framelayout ALTER COLUMN id SET DEFAULT nextval('public.framelayout_id_seq'::regclass);


--
-- TOC entry 2873 (class 2604 OID 247587)
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- TOC entry 2877 (class 2604 OID 247588)
-- Name: schedulecontentassociation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedulecontentassociation ALTER COLUMN id SET DEFAULT nextval('public.schedulecontentassociation_id_seq'::regclass);


--
-- TOC entry 2880 (class 2604 OID 247589)
-- Name: scheduledeviceassociation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduledeviceassociation ALTER COLUMN id SET DEFAULT nextval('public.scheduledeviceassociation_id_seq'::regclass);


--
-- TOC entry 2881 (class 2604 OID 247590)
-- Name: schedulepermission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedulepermission ALTER COLUMN id SET DEFAULT nextval('public.schedulepermission_id_seq'::regclass);


--
-- TOC entry 2912 (class 2604 OID 247637)
-- Name: timezone id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timezone ALTER COLUMN id SET DEFAULT nextval('public.timezone_id_seq'::regclass);


--
-- TOC entry 2911 (class 2604 OID 247591)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 3086 (class 0 OID 247378)
-- Dependencies: 202
-- Data for Name: contentlibrary; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contentlibrary (id, label, src, createdon, createdby, isapproved, approvedon, approvedby, type, folderid, restorefolderid, size, width, height, extension, duration, status, archivedon, deletedon, editedon, editedby, iscompleted, optimizevideo, detail, expireon, serverid, activefrom, activeto, oncecompleted, processedsize, settings, isscene, uploadgroupid, issensitivitychk, mailsent, isblur, issensitivitychkforcopy, uploadsource, asanaattachid) FROM stdin;
1	Trial Default Content.png	1574859838.1345-trial-default-content.png	2019-11-27 08:03:58	1	1	2019-11-27 08:03:58	1	0	0	0	34.45	1920	1080	PNG	0.00	0	\N	\N	\N	\N	1	1	{"noofpages":0,"timeZoneOffset":0}	\N	0	\N	\N	0	35272	\N	0	0	0	0	0	0	0	0
2	Teamplate-6-D.jpg	1737356146.7289-teamplate-6-d.jpg	2025-07-25 12:46:29	1	1	2025-07-25 12:46:29	1	0	0	0	1074.05	1920	1080	JPG	0.00	0	\N	\N	\N	0	1	1	{"timeZoneOffset":0,"noofpages":0}	\N	0	\N	\N	0	1099826	\N	0	0	0	0	0	0	0	0
3	Teamplate-5.jpg	1737113433.2188-teamplate-5.jpg	2025-07-25 12:47:45	1	1	2025-07-25 12:47:45	1	0	0	0	757.67	1920	1080	JPG	0.00	0	\N	\N	\N	0	1	1	{"timeZoneOffset":0,"noofpages":0}	\N	0	\N	\N	0	775857	\N	0	0	0	0	0	0	0	0
4	Toronto, CA	6167865	2025-07-25 12:47:45	1	1	2025-07-25 12:47:45	1	4	0	0	\N	\N	\N	\N	\N	0	\N	\N	\N	0	1	1	{"labelOpt": "a", "ctype": {"tint": "monochrome"}, "timeZoneOffset": null, "cityOpt": "c", "city_label": "Toronto, CA", "forecast": "0", "wsu": "ms"}	\N	0	\N	\N	0	\N	\N	0	0	0	0	0	0	0	0
5	Jess Calendar	Jess Calendar	2025-07-25 12:48:57	1	1	2025-07-25 12:48:57	1	9	0	0	\N	\N	\N	\N	\N	0	\N	\N	\N	0	1	1	{"widgetversion":1619015361,"timeZoneOffset":null,"ctype":{"rb":{"bg":"monochrome","ssbg":"monochrome","titleText":"monochrome","subtitleText":"monochrome","timeText":"monochrome"},"wb":{"bg":"monochrome","ssbg":"monochrome","headerBg":"monochrome","headerText":"default","titleText":"monochrome","timeText":"monochrome","roomText":"monochrome","altTitleText":"monochrome","altTimeText":"monochrome","altRoomText":"monochrome","rowBg":"monochrome","altBg":"monochrome"}}}	\N	0	\N	\N	0	\N	\N	0	0	0	0	0	0	0	0
6	Days Since Last Lost Time Accident	Days Since Last Lost Time Accident	2025-07-25 12:48:57	1	1	2025-07-25 12:48:57	1	56	0	0	\N	\N	\N	\N	\N	0	\N	\N	\N	0	1	1	{"timeZoneOffset":null,"dType":"u","ctype":{"countText":"default","bg":"monochrome","headerText":"monochrome","footerText":"monochrome","labelText":"monochrome"},"cnType":"d"}	\N	0	\N	\N	0	\N	\N	0	0	0	0	0	0	0	0
110	lsquared-wallpaer.png	1759993463.6734-lsquared-wallpaer.png	2025-10-09 07:04:24	1	1	2025-10-09 07:04:24	1	0	0	0	43.43	1920	1080	PNG	0.00	0	\N	\N	\N	\N	1	1	{"noofpages":0,"timeZoneOffset":0,"totaluploadcount":"3"}	\N	2	\N	\N	0	44469	\N	0	dyb4vr6e1759993460705	0	0	0	0	0	0
111	png.png	1759993469.5438-png.png	2025-10-09 07:04:30	1	1	2025-10-09 07:04:30	1	0	0	0	2547.72	1920	1080	PNG	0.00	0	\N	\N	\N	\N	1	1	{"noofpages":0,"timeZoneOffset":0,"totaluploadcount":"3"}	\N	2	\N	\N	0	2608866	\N	0	dyb4vr6e1759993460705	0	0	0	0	0	0
112	tif.tif	1759993472.1979-tif.jpg	2025-10-09 07:04:32	1	1	2025-10-09 07:04:32	1	0	0	0	5139.55	0	0	TIF	0.00	0	\N	\N	\N	\N	0	1	{"noofpages":0,"timeZoneOffset":0,"totaluploadcount":"3","cloudConvert":"babe5427-0d9a-4437-bdd6-bca0e5a9f75e","media_server":"cloudConvert"}	\N	2	\N	\N	0	\N	\N	0	dyb4vr6e1759993460705	0	0	0	0	0	0
\.


--
-- TOC entry 3088 (class 0 OID 247399)
-- Dependencies: 204
-- Data for Name: contentpermission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contentpermission (id, contentid, usergroupid) FROM stdin;
268	110	0
269	111	0
270	112	0
\.


--
-- TOC entry 3090 (class 0 OID 247404)
-- Dependencies: 206
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device (id, name, hardwareid, os, publicip, localip, slideversion, watcherversion, resolution, connectionstatus, createdon, createdby, timezone, updateversion, isactive, autoupdate, offlinereboot, lastxmlgeneratedon, thumbversion, serverid, space, localdatetime, devicetype, lanaccessible, computername, guid, tzname, scheduledsize, resourcesize, woeid, updateversion_em, displaytime_em, raw_time_on_device, time_on_device, notifiedon, info, emptyfeed_notifiedon, client, isticket, eslinfo, migratedon, notifiedon_bigpanda, firsttimemigrate, cc, firstconnected, notifiedon_hubspot, folderid, report_settings) FROM stdin;
18	Device 11	d-iot-11	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994746	1	1	1	\N	0	2	\N	\N	mp	\N	\N	61D44379-08EE-4DE6-947E-5F34AE60635D	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-11","isEditable":false,"vType":"t","site__identifier":"d-iot-11"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
9	Device 2	d-iot-2	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994724	1	1	1	\N	0	2	\N	\N	mp	\N	\N	2E7CF416-D2ED-4C77-96C2-0B94BFA81B4B	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-2","isEditable":false,"vType":"t","site__identifier":"d-iot-2"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
14	Device 7	d-iot-7	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994718	1	1	1	\N	0	2	\N	\N	mp	\N	\N	59C735C4-4B9C-49AB-B9E8-523B3C6E1792	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-7","isEditable":false,"vType":"t","site__identifier":"d-iot-7"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
17	Device 10	d-iot-10	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994727	1	1	1	\N	0	2	\N	\N	mp	\N	\N	BE15C1AC-0B31-4F9D-8FAC-65ACFCE9CCF9	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-10","isEditable":false,"vType":"t","site__identifier":"d-iot-10"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
20	Device 13	d-iot-13	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994752	1	1	1	\N	0	2	\N	\N	mp	\N	\N	7FA585D3-C239-4F5F-9A1F-92E51C45B009	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-13","isEditable":false,"vType":"t","site__identifier":"d-iot-13"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
10	Device 3	d-iot-3	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994747	1	1	1	\N	0	2	\N	\N	mp	\N	\N	33F67FE4-8093-4AF9-81FF-C47632FDAE93	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-3","isEditable":false,"vType":"t","site__identifier":"d-iot-3"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
11	Device 4	d-iot-4	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994750	1	1	1	\N	0	2	\N	\N	mp	\N	\N	DDC755AC-7F5F-4826-B3B7-A5A540BB4C50	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-4","isEditable":false,"vType":"t","site__identifier":"d-iot-4"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
19	Device 12	d-iot-12	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994725	1	1	1	\N	0	2	\N	\N	mp	\N	\N	64B2502C-FF8E-45E0-BEBB-ED7D14CA15FD	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-12","isEditable":false,"vType":"t","site__identifier":"d-iot-12"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
16	Device 9	d-iot-9	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994727	1	1	1	\N	0	2	\N	\N	mp	\N	\N	7A9D8C10-BB4E-43E5-ACCB-36BE90C8738E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-9","isEditable":false,"vType":"t","site__identifier":"d-iot-9"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
22	Device 15	d-iot-15	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994713	1	1	1	\N	0	2	\N	\N	mp	\N	\N	BCACE3A5-D661-46F2-9E12-7A8ADFE33D14	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-15","isEditable":false,"vType":"t","site__identifier":"d-iot-15"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
15	Device 8	d-iot-8	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994707	1	1	1	\N	0	2	\N	\N	mp	\N	\N	950FD2C3-595C-4D6D-AED5-E0070E794972	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-8","isEditable":false,"vType":"t","site__identifier":"d-iot-8"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
12	Device 5	d-iot-5	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994701	1	1	1	\N	0	2	\N	\N	mp	\N	\N	74127D80-1B36-4FD1-A906-BDF0B314491B	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-5","isEditable":false,"vType":"t","site__identifier":"d-iot-5"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
21	Device 14	d-iot-14	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994743	1	1	1	\N	0	2	\N	\N	mp	\N	\N	23F23A6E-2AAD-4534-835B-689249AC3897	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-14","isEditable":false,"vType":"t","site__identifier":"d-iot-14"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
13	Device 6	d-iot-6	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994723	1	1	1	\N	0	2	\N	\N	mp	\N	\N	63397783-4053-4448-8BA2-7B7AEDC92D7D	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-6","isEditable":false,"vType":"t","site__identifier":"d-iot-6"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
70	Device 63	d-iot-63	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994741	1	1	1	\N	0	2	\N	\N	mp	\N	\N	0ACE60D7-E02C-40CB-81E4-288ABE9BC16E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-63","isEditable":false,"vType":"t","site__identifier":"d-iot-63"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
36	Device 29	d-iot-29	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994734	1	1	1	\N	0	2	\N	\N	mp	\N	\N	FD2824F8-A447-482C-B713-ABCD9D48E31D	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-29","isEditable":false,"vType":"t","site__identifier":"d-iot-29"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
42	Device 35	d-iot-35	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994728	1	1	1	\N	0	2	\N	\N	mp	\N	\N	CDE5E798-2494-4678-9CDF-50987A5306D9	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-35","isEditable":false,"vType":"t","site__identifier":"d-iot-35"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
35	Device 28	d-iot-28	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994705	1	1	1	\N	0	2	\N	\N	mp	\N	\N	6162D299-3B37-41F2-8BA7-C41964600CA0	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-28","isEditable":false,"vType":"t","site__identifier":"d-iot-28"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
31	Device 24	d-iot-24	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994754	1	1	1	\N	0	2	\N	\N	mp	\N	\N	7CBD0A9B-00D0-4631-AC3D-29BC3CEB9C20	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-24","isEditable":false,"vType":"t","site__identifier":"d-iot-24"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
25	Device 18	d-iot-18	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994710	1	1	1	\N	0	2	\N	\N	mp	\N	\N	D621BEDD-0A20-4259-8C42-F85D76BDF4E1	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-18","isEditable":false,"vType":"t","site__identifier":"d-iot-18"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
41	Device 34	d-iot-34	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994724	1	1	1	\N	0	2	\N	\N	mp	\N	\N	B925D3FC-EC94-447C-831A-586B0EFB805A	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-34","isEditable":false,"vType":"t","site__identifier":"d-iot-34"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
27	Device 20	d-iot-20	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994731	1	1	1	\N	0	2	\N	\N	mp	\N	\N	0944B4E5-2E29-4359-821B-3F265DF40986	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-20","isEditable":false,"vType":"t","site__identifier":"d-iot-20"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
39	Device 32	d-iot-32	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994712	1	1	1	\N	0	2	\N	\N	mp	\N	\N	16A3D0BC-8DF0-4BF2-BC3E-8DF09EE081F3	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-32","isEditable":false,"vType":"t","site__identifier":"d-iot-32"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
30	Device 23	d-iot-23	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994733	1	1	1	\N	0	2	\N	\N	mp	\N	\N	E833E7DA-B64C-43DF-97A3-7B92D7208FB3	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-23","isEditable":false,"vType":"t","site__identifier":"d-iot-23"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
38	Device 31	d-iot-31	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994728	1	1	1	\N	0	2	\N	\N	mp	\N	\N	CD70D064-026D-42B2-B6F3-E209291CBF7F	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-31","isEditable":false,"vType":"t","site__identifier":"d-iot-31"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
40	Device 33	d-iot-33	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994747	1	1	1	\N	0	2	\N	\N	mp	\N	\N	EEB0296D-A476-4E7F-A4B5-106C0DD16625	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-33","isEditable":false,"vType":"t","site__identifier":"d-iot-33"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
32	Device 25	d-iot-25	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994733	1	1	1	\N	0	2	\N	\N	mp	\N	\N	9660E9C5-8AAA-439D-9AE2-763E4364CEFC	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-25","isEditable":false,"vType":"t","site__identifier":"d-iot-25"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
33	Device 26	d-iot-26	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994742	1	1	1	\N	0	2	\N	\N	mp	\N	\N	D714A203-9ECE-4A2F-A96A-51C6A277C5D6	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-26","isEditable":false,"vType":"t","site__identifier":"d-iot-26"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
24	Device 17	d-iot-17	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994737	1	1	1	\N	0	2	\N	\N	mp	\N	\N	08F9F2FD-8696-481E-B23D-3C0F2745D70E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-17","isEditable":false,"vType":"t","site__identifier":"d-iot-17"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
37	Device 30	d-iot-30	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994714	1	1	1	\N	0	2	\N	\N	mp	\N	\N	4471684D-269E-4A10-848B-5D7B1E299A43	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-30","isEditable":false,"vType":"t","site__identifier":"d-iot-30"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
29	Device 22	d-iot-22	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994737	1	1	1	\N	0	2	\N	\N	mp	\N	\N	773516EE-2576-427E-AAD0-C438E3FAA233	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-22","isEditable":false,"vType":"t","site__identifier":"d-iot-22"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
28	Device 21	d-iot-21	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994740	1	1	1	\N	0	2	\N	\N	mp	\N	\N	F5AA30BD-50A0-4871-94DA-11EECB54F7EE	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-21","isEditable":false,"vType":"t","site__identifier":"d-iot-21"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
34	Device 27	d-iot-27	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994753	1	1	1	\N	0	2	\N	\N	mp	\N	\N	FD636D73-7199-46CD-85B7-6304F33174F4	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-27","isEditable":false,"vType":"t","site__identifier":"d-iot-27"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
26	Device 19	d-iot-19	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994715	1	1	1	\N	0	2	\N	\N	mp	\N	\N	9A68BD95-6256-45A1-902A-7BA82AFCB2C6	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-19","isEditable":false,"vType":"t","site__identifier":"d-iot-19"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
85	Device 78	d-iot-78	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994731	1	1	1	\N	0	2	\N	\N	mp	\N	\N	459E53F0-BFEF-4915-8608-480647633BCF	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-78","isEditable":false,"vType":"t","site__identifier":"d-iot-78"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
83	Device 76	d-iot-76	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994703	1	1	1	\N	0	2	\N	\N	mp	\N	\N	3F6312B2-E302-41A1-A2C2-AC88072D17E2	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-76","isEditable":false,"vType":"t","site__identifier":"d-iot-76"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
84	Device 77	d-iot-77	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994708	1	1	1	\N	0	2	\N	\N	mp	\N	\N	825A44DF-C9A8-4376-9CD4-6A9819B01E97	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-77","isEditable":false,"vType":"t","site__identifier":"d-iot-77"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
71	Device 64	d-iot-64	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994726	1	1	1	\N	0	2	\N	\N	mp	\N	\N	B988560C-2FC6-4081-85A6-BC971800DB68	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-64","isEditable":false,"vType":"t","site__identifier":"d-iot-64"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
72	Device 65	d-iot-65	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994725	1	1	1	\N	0	2	\N	\N	mp	\N	\N	D49DEAD5-6B37-40E7-8F21-634399E96951	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-65","isEditable":false,"vType":"t","site__identifier":"d-iot-65"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
69	Device 62	d-iot-62	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994736	1	1	1	\N	0	2	\N	\N	mp	\N	\N	5B29A859-56F8-4FD7-99CB-7B9C1B0F37D3	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-62","isEditable":false,"vType":"t","site__identifier":"d-iot-62"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
64	Device 57	d-iot-57	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994734	1	1	1	\N	0	2	\N	\N	mp	\N	\N	0E977ADA-297A-4F67-B64A-E66BE6E5F9DD	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-57","isEditable":false,"vType":"t","site__identifier":"d-iot-57"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
75	Device 68	d-iot-68	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994756	1	1	1	\N	0	2	\N	\N	mp	\N	\N	1C8F6201-D285-4844-AE09-950783291C33	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-68","isEditable":false,"vType":"t","site__identifier":"d-iot-68"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
80	Device 73	d-iot-73	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994711	1	1	1	\N	0	2	\N	\N	mp	\N	\N	10B26C82-C162-4E4F-9436-D5817D30F801	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-73","isEditable":false,"vType":"t","site__identifier":"d-iot-73"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
67	Device 60	d-iot-60	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994755	1	1	1	\N	0	2	\N	\N	mp	\N	\N	096726E0-F6A3-4D03-BA70-11E59E737F68	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-60","isEditable":false,"vType":"t","site__identifier":"d-iot-60"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
82	Device 75	d-iot-75	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994745	1	1	1	\N	0	2	\N	\N	mp	\N	\N	71B92B7B-478A-46AC-ABEC-6FD6976C1CF7	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-75","isEditable":false,"vType":"t","site__identifier":"d-iot-75"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
73	Device 66	d-iot-66	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994732	1	1	1	\N	0	2	\N	\N	mp	\N	\N	6FFF9EA8-F6CB-43CF-AF77-D9EB67F66DD6	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-66","isEditable":false,"vType":"t","site__identifier":"d-iot-66"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
68	Device 61	d-iot-61	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994705	1	1	1	\N	0	2	\N	\N	mp	\N	\N	6A344D2B-B379-4E39-A84B-84FCC5DBF6E5	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-61","isEditable":false,"vType":"t","site__identifier":"d-iot-61"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
81	Device 74	d-iot-74	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994751	1	1	1	\N	0	2	\N	\N	mp	\N	\N	E715B21F-B1A5-4D54-A0B2-0153FF6258BC	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-74","isEditable":false,"vType":"t","site__identifier":"d-iot-74"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
65	Device 58	d-iot-58	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994753	1	1	1	\N	0	2	\N	\N	mp	\N	\N	AC3728B9-0B5B-42DF-B2F2-135B8F31328F	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-58","isEditable":false,"vType":"t","site__identifier":"d-iot-58"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
8	Device 1	d-iot-1	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994706	1	1	1	\N	0	2	\N	\N	mp	\N	\N	5D338C3B-0929-485E-AE52-EA9416C3BE92	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-1","isEditable":false,"vType":"t","site__identifier":"d-iot-1"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
79	Device 72	d-iot-72	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994719	1	1	1	\N	0	2	\N	\N	mp	\N	\N	48F8FD72-F1F2-41E1-99B7-5F62304A38AA	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-72","isEditable":false,"vType":"t","site__identifier":"d-iot-72"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
74	Device 67	d-iot-67	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994744	1	1	1	\N	0	2	\N	\N	mp	\N	\N	D1C4FFA1-9F83-4EB0-AD01-BDB6964BD27A	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-67","isEditable":false,"vType":"t","site__identifier":"d-iot-67"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
78	Device 71	d-iot-71	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994749	1	1	1	\N	0	2	\N	\N	mp	\N	\N	A0E8044A-3F7C-4649-8385-B62819CFC1C0	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-71","isEditable":false,"vType":"t","site__identifier":"d-iot-71"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
76	Device 69	d-iot-69	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994722	1	1	1	\N	0	2	\N	\N	mp	\N	\N	1C24E75F-9042-4FF4-AA0D-2073D55B657E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-69","isEditable":false,"vType":"t","site__identifier":"d-iot-69"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
77	Device 70	d-iot-70	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994700	1	1	1	\N	0	2	\N	\N	mp	\N	\N	C71E7739-DD48-4A71-86EE-CB1129650081	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-70","isEditable":false,"vType":"t","site__identifier":"d-iot-70"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
55	Device 48	d-iot-48	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994701	1	1	1	\N	0	2	\N	\N	mp	\N	\N	D2C6BBF1-ED33-4769-9D32-E5EC96538DCF	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-48","isEditable":false,"vType":"t","site__identifier":"d-iot-48"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
44	Device 37	d-iot-37	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994714	1	1	1	\N	0	2	\N	\N	mp	\N	\N	19DC7D98-FC0F-4ED7-84F1-FCE1F220003B	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-37","isEditable":false,"vType":"t","site__identifier":"d-iot-37"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
45	Device 38	d-iot-38	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994756	1	1	1	\N	0	2	\N	\N	mp	\N	\N	5F72DDE0-7E79-46A1-9343-065A50838B42	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-38","isEditable":false,"vType":"t","site__identifier":"d-iot-38"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
54	Device 47	d-iot-47	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994703	1	1	1	\N	0	2	\N	\N	mp	\N	\N	A0AB3452-CC86-4A5B-9E70-487EA1C73992	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-47","isEditable":false,"vType":"t","site__identifier":"d-iot-47"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
47	Device 40	d-iot-40	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994746	1	1	1	\N	0	2	\N	\N	mp	\N	\N	F0FF3996-533E-4EFC-9EED-E21F15ED3367	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-40","isEditable":false,"vType":"t","site__identifier":"d-iot-40"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
46	Device 39	d-iot-39	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994745	1	1	1	\N	0	2	\N	\N	mp	\N	\N	06A3EEB0-309E-44CC-AAFC-16FD9AA6B62E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-39","isEditable":false,"vType":"t","site__identifier":"d-iot-39"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
50	Device 43	d-iot-43	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994729	1	1	1	\N	0	2	\N	\N	mp	\N	\N	00A257D9-2901-4815-AE67-A9525EFAEB48	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-43","isEditable":false,"vType":"t","site__identifier":"d-iot-43"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
60	Device 53	d-iot-53	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994729	1	1	1	\N	0	2	\N	\N	mp	\N	\N	48DF1633-49FB-419E-A9C4-B1A1D8CEF5C8	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-53","isEditable":false,"vType":"t","site__identifier":"d-iot-53"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
49	Device 42	d-iot-42	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994712	1	1	1	\N	0	2	\N	\N	mp	\N	\N	4D2F13E5-7FF1-4648-8AD0-6A8FB33E02D0	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-42","isEditable":false,"vType":"t","site__identifier":"d-iot-42"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
56	Device 49	d-iot-49	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994739	1	1	1	\N	0	2	\N	\N	mp	\N	\N	B4FADD47-E234-4BAE-A0D7-D977FBB6EBD4	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-49","isEditable":false,"vType":"t","site__identifier":"d-iot-49"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
59	Device 52	d-iot-52	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994741	1	1	1	\N	0	2	\N	\N	mp	\N	\N	1668FE77-D55C-466D-8C24-B6B6998CE960	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-52","isEditable":false,"vType":"t","site__identifier":"d-iot-52"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
52	Device 45	d-iot-45	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994721	1	1	1	\N	0	2	\N	\N	mp	\N	\N	02069E98-8501-4EC7-B6E3-BBDB8D8ED389	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-45","isEditable":false,"vType":"t","site__identifier":"d-iot-45"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
61	Device 54	d-iot-54	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994720	1	1	1	\N	0	2	\N	\N	mp	\N	\N	D67AB7E7-1D24-447F-90A5-6B666A91D380	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-54","isEditable":false,"vType":"t","site__identifier":"d-iot-54"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
58	Device 51	d-iot-51	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994708	1	1	1	\N	0	2	\N	\N	mp	\N	\N	C14BC2DD-2913-4CF3-95F0-0AB7D9452528	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-51","isEditable":false,"vType":"t","site__identifier":"d-iot-51"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
57	Device 50	d-iot-50	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994742	1	1	1	\N	0	2	\N	\N	mp	\N	\N	19795A35-87A2-4787-AE77-10CC7BC81C0B	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-50","isEditable":false,"vType":"t","site__identifier":"d-iot-50"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
48	Device 41	d-iot-41	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994732	1	1	1	\N	0	2	\N	\N	mp	\N	\N	59B78068-97FB-4B56-994D-164E9EA62227	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-41","isEditable":false,"vType":"t","site__identifier":"d-iot-41"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
51	Device 44	d-iot-44	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994707	1	1	1	\N	0	2	\N	\N	mp	\N	\N	E938A696-A776-40E1-8CE1-124AAEF0A160	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-44","isEditable":false,"vType":"t","site__identifier":"d-iot-44"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
53	Device 46	d-iot-46	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994736	1	1	1	\N	0	2	\N	\N	mp	\N	\N	52E0E8B1-01D8-42EA-8115-2F61D8306AC3	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-46","isEditable":false,"vType":"t","site__identifier":"d-iot-46"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
62	Device 55	d-iot-55	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994743	1	1	1	\N	0	2	\N	\N	mp	\N	\N	16E9FD5D-4300-4DAC-A1EB-E444823D21FE	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-55","isEditable":false,"vType":"t","site__identifier":"d-iot-55"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
106	Device 99	d-iot-99	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994710	1	1	1	\N	0	2	\N	\N	mp	\N	\N	6C4387B2-3C9B-4782-AD84-453AF815853E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-99","isEditable":false,"vType":"t","site__identifier":"d-iot-99"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
88	Device 81	d-iot-81	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994738	1	1	1	\N	0	2	\N	\N	mp	\N	\N	F5EC8F1E-89DF-40D5-B3CB-34A7272467CE	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-81","isEditable":false,"vType":"t","site__identifier":"d-iot-81"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
87	Device 80	d-iot-80	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994711	1	1	1	\N	0	2	\N	\N	mp	\N	\N	C80FD8A5-EDA7-4484-807B-61D03B65537C	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-80","isEditable":false,"vType":"t","site__identifier":"d-iot-80"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
92	Device 85	d-iot-85	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994740	1	1	1	\N	0	2	\N	\N	mp	\N	\N	4DC68228-8300-4F3F-88AE-1CAFF270EE5E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-85","isEditable":false,"vType":"t","site__identifier":"d-iot-85"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
90	Device 83	d-iot-83	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994748	1	1	1	\N	0	2	\N	\N	mp	\N	\N	9D9E4246-34A1-40E6-B16B-4228581E0120	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-83","isEditable":false,"vType":"t","site__identifier":"d-iot-83"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
43	Device 36	d-iot-36	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994718	1	1	1	\N	0	2	\N	\N	mp	\N	\N	96019C68-147B-4133-8180-32A98777078E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-36","isEditable":false,"vType":"t","site__identifier":"d-iot-36"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
101	Device 94	d-iot-94	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994723	1	1	1	\N	0	2	\N	\N	mp	\N	\N	754B4C37-A1A7-4ABC-A41E-1FB19F7A748A	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-94","isEditable":false,"vType":"t","site__identifier":"d-iot-94"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
95	Device 88	d-iot-88	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994709	1	1	1	\N	0	2	\N	\N	mp	\N	\N	4C1B55CD-79C6-4477-A7EE-B13738BE5F86	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-88","isEditable":false,"vType":"t","site__identifier":"d-iot-88"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
93	Device 86	d-iot-86	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994715	1	1	1	\N	0	2	\N	\N	mp	\N	\N	4AC37517-B8DF-43EC-9F83-C412CFB48CFD	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-86","isEditable":false,"vType":"t","site__identifier":"d-iot-86"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
103	Device 96	d-iot-96	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994716	1	1	1	\N	0	2	\N	\N	mp	\N	\N	0CE9647A-D3DF-4DD3-980F-A7B00E9943B4	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-96","isEditable":false,"vType":"t","site__identifier":"d-iot-96"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
97	Device 90	d-iot-90	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994720	1	1	1	\N	0	2	\N	\N	mp	\N	\N	C3CD0E53-2B9B-49E9-8092-580D102C3F2F	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-90","isEditable":false,"vType":"t","site__identifier":"d-iot-90"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
23	Device 16	d-iot-16	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994721	1	1	1	\N	0	2	\N	\N	mp	\N	\N	F6849C60-7A4A-4EEE-A9E8-56CD2E4133A8	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-16","isEditable":false,"vType":"t","site__identifier":"d-iot-16"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
98	Device 91	d-iot-91	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994754	1	1	1	\N	0	2	\N	\N	mp	\N	\N	3AD07954-4F22-471B-A21B-E8ABE3CCCB2B	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-91","isEditable":false,"vType":"t","site__identifier":"d-iot-91"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
100	Device 93	d-iot-93	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994704	1	1	1	\N	0	2	\N	\N	mp	\N	\N	68F04951-AE0E-4391-BE4F-DCDEA5B0D743	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-93","isEditable":false,"vType":"t","site__identifier":"d-iot-93"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
99	Device 92	d-iot-92	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994719	1	1	1	\N	0	2	\N	\N	mp	\N	\N	0C779EF6-FC70-4BB3-820B-A2C0F8127549	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-92","isEditable":false,"vType":"t","site__identifier":"d-iot-92"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
91	Device 84	d-iot-84	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994757	1	1	1	\N	0	2	\N	\N	mp	\N	\N	2B39C0F9-39B4-4DA3-810D-D93AD7AB5F60	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-84","isEditable":false,"vType":"t","site__identifier":"d-iot-84"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
105	Device 98	d-iot-98	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994717	1	1	1	\N	0	2	\N	\N	mp	\N	\N	70B1873C-C2AC-419D-B40B-686529D54DC4	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-98","isEditable":false,"vType":"t","site__identifier":"d-iot-98"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
104	Device 97	d-iot-97	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994749	1	1	1	\N	0	2	\N	\N	mp	\N	\N	20BE8E19-E023-456B-9076-EAC4AF760F43	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-97","isEditable":false,"vType":"t","site__identifier":"d-iot-97"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
102	Device 95	d-iot-95	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994702	1	1	1	\N	0	2	\N	\N	mp	\N	\N	E2B67D41-3F87-4CA3-AF20-674D73B4864C	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-95","isEditable":false,"vType":"t","site__identifier":"d-iot-95"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
96	Device 89	d-iot-89	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994750	1	1	1	\N	0	2	\N	\N	mp	\N	\N	1C6332FD-C519-498F-A318-05271CE8D281	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-89","isEditable":false,"vType":"t","site__identifier":"d-iot-89"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
94	Device 87	d-iot-87	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994730	1	1	1	\N	0	2	\N	\N	mp	\N	\N	B0889C31-22BF-41D5-AE21-6E0B43D8CAA0	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-87","isEditable":false,"vType":"t","site__identifier":"d-iot-87"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
107	Device 100	d-iot-100	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994716	1	1	1	\N	0	2	\N	\N	mp	\N	\N	AA981875-3511-4726-9FF0-1C6AFCE4AB2E	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-100","isEditable":false,"vType":"t","site__identifier":"d-iot-100"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
89	Device 82	d-iot-82	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994704	1	1	1	\N	0	2	\N	\N	mp	\N	\N	D3D768EC-E29A-402C-81A5-62D0E5BE7B93	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-82","isEditable":false,"vType":"t","site__identifier":"d-iot-82"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
66	Device 59	d-iot-59	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994735	1	1	1	\N	0	2	\N	\N	mp	\N	\N	555F9AE7-9BEF-490C-8857-42246C5A6289	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-59","isEditable":false,"vType":"t","site__identifier":"d-iot-59"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
63	Device 56	d-iot-56	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994738	1	1	1	\N	0	2	\N	\N	mp	\N	\N	902FEDB6-F3B8-4A80-A36A-6CD30B4ABEB5	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-56","isEditable":false,"vType":"t","site__identifier":"d-iot-56"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
86	Device 79	d-iot-79	1	\N	\N	\N	\N	\N	\N	2025-10-09 06:56:10	1	America/Toronto	1759994752	1	1	1	\N	0	2	\N	\N	mp	\N	\N	3ACC05CA-9133-434D-8739-F6EA7F2FF365	Eastern Standard Time	2653335	0	6167865	0	\N	\N	\N	\N	[{"label":"Site Identifier","value":"d-iot-79","isEditable":false,"vType":"t","site__identifier":"d-iot-79"}]	\N	0	0	\N	\N	\N	s	\N	\N	\N	0	0
\.


--
-- TOC entry 3092 (class 0 OID 247425)
-- Dependencies: 208
-- Data for Name: deviceextraips; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deviceextraips (id, deviceid, hardwareid, name, description) FROM stdin;
\.


--
-- TOC entry 3122 (class 0 OID 247640)
-- Dependencies: 238
-- Data for Name: devicemigrationhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devicemigrationhistory (id, deviceid, fromhardwareid, tohardwareid, migratedon, migratedby, reason) FROM stdin;
\.


--
-- TOC entry 3125 (class 0 OID 247670)
-- Dependencies: 241
-- Data for Name: devicepermission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devicepermission (id, deviceid, usergroupid) FROM stdin;
7	8	0
8	9	0
9	10	0
10	11	0
11	12	0
12	13	0
13	14	0
14	15	0
15	16	0
16	17	0
17	18	0
18	19	0
19	20	0
20	21	0
21	22	0
22	23	0
23	24	0
24	25	0
25	26	0
26	27	0
27	28	0
28	29	0
29	30	0
30	31	0
31	32	0
32	33	0
33	34	0
34	35	0
35	36	0
36	37	0
37	38	0
38	39	0
39	40	0
40	41	0
41	42	0
42	43	0
43	44	0
44	45	0
45	46	0
46	47	0
47	48	0
48	49	0
49	50	0
50	51	0
51	52	0
52	53	0
53	54	0
54	55	0
55	56	0
56	57	0
57	58	0
58	59	0
59	60	0
60	61	0
61	62	0
62	63	0
63	64	0
64	65	0
65	66	0
66	67	0
67	68	0
68	69	0
69	70	0
70	71	0
71	72	0
72	73	0
73	74	0
74	75	0
75	76	0
76	77	0
77	78	0
78	79	0
79	80	0
80	81	0
81	82	0
82	83	0
83	84	0
84	85	0
85	86	0
86	87	0
87	88	0
88	89	0
89	90	0
90	91	0
91	92	0
92	93	0
93	94	0
94	95	0
95	96	0
96	97	0
97	98	0
98	99	0
99	100	0
100	101	0
101	102	0
102	103	0
103	104	0
104	105	0
105	106	0
106	107	0
\.


--
-- TOC entry 3094 (class 0 OID 247430)
-- Dependencies: 210
-- Data for Name: deviceproperties; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deviceproperties (id, label, val, createdon, createdby, serverid, sort, descriptions, vtype) FROM stdin;
\.


--
-- TOC entry 3096 (class 0 OID 247439)
-- Dependencies: 212
-- Data for Name: devicepropertiesassociation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devicepropertiesassociation (id, dpid, deviceid, val, vtype) FROM stdin;
2	0	8		t
11	0	17		t
101	0	107		t
12	0	18		t
13	0	19		t
14	0	20		t
15	0	21		t
16	0	22		t
17	0	23		t
18	0	24		t
19	0	25		t
20	0	26		t
3	0	9		t
21	0	27		t
22	0	28		t
23	0	29		t
24	0	30		t
25	0	31		t
26	0	32		t
27	0	33		t
28	0	34		t
29	0	35		t
30	0	36		t
4	0	10		t
31	0	37		t
32	0	38		t
33	0	39		t
34	0	40		t
35	0	41		t
36	0	42		t
37	0	43		t
38	0	44		t
39	0	45		t
40	0	46		t
5	0	11		t
41	0	47		t
42	0	48		t
43	0	49		t
44	0	50		t
45	0	51		t
46	0	52		t
47	0	53		t
48	0	54		t
49	0	55		t
50	0	56		t
6	0	12		t
51	0	57		t
52	0	58		t
53	0	59		t
54	0	60		t
55	0	61		t
56	0	62		t
57	0	63		t
58	0	64		t
59	0	65		t
60	0	66		t
7	0	13		t
61	0	67		t
62	0	68		t
63	0	69		t
64	0	70		t
65	0	71		t
66	0	72		t
67	0	73		t
68	0	74		t
69	0	75		t
70	0	76		t
8	0	14		t
71	0	77		t
72	0	78		t
73	0	79		t
74	0	80		t
75	0	81		t
76	0	82		t
77	0	83		t
78	0	84		t
79	0	85		t
80	0	86		t
9	0	15		t
81	0	87		t
82	0	88		t
83	0	89		t
84	0	90		t
85	0	91		t
86	0	92		t
87	0	93		t
88	0	94		t
89	0	95		t
90	0	96		t
10	0	16		t
91	0	97		t
92	0	98		t
93	0	99		t
94	0	100		t
95	0	101		t
96	0	102		t
97	0	103		t
98	0	104		t
99	0	105		t
100	0	106		t
\.


--
-- TOC entry 3098 (class 0 OID 247448)
-- Dependencies: 214
-- Data for Name: devicesetting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devicesetting (id, deviceid, screenshotcapture, screenshotinterval, datathreshold, warningdatalimit, terminatedatalimit, warningemail, warningmailsent, feedrestriction, feedrestrictionstarton, feedrestrictionendon, overridedownloadsize, polling, desktopdisplaymodes, desktoprefreshrate, desktopcolordepth, requesteddisplaymode, displaymoderequestedon, displaymodeacknowledgedon, screenshotstatus, detail) FROM stdin;
8	8	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
9	9	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
10	10	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
11	11	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
12	12	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
13	13	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
14	14	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
15	15	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
16	16	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
17	17	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
18	18	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
19	19	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
20	20	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
21	21	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
22	22	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
23	23	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
24	24	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
25	25	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
26	26	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
27	27	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
28	28	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
29	29	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
30	30	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
31	31	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
32	32	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
33	33	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
34	34	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
35	35	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
36	36	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
37	37	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
38	38	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
39	39	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
40	40	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
41	41	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
42	42	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
43	43	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
44	44	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
45	45	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
46	46	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
47	47	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
48	48	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
49	49	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
50	50	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
51	51	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
52	52	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
53	53	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
54	54	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
55	55	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
56	56	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
57	57	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
58	58	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
59	59	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
60	60	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
61	61	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
62	62	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
63	63	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
64	64	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
65	65	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
66	66	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
67	67	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
68	68	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
69	69	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
70	70	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
71	71	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
72	72	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
73	73	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
74	74	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
75	75	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
76	76	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
77	77	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
78	78	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
79	79	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
80	80	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
81	81	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
82	82	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
83	83	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
84	84	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
85	85	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
86	86	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
87	87	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
88	88	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
89	89	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
90	90	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
91	91	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
92	92	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
93	93	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
94	94	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
95	95	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
96	96	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
97	97	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
98	98	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
99	99	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
100	100	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
101	101	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
102	102	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
103	103	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
104	104	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
105	105	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
106	106	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
107	107	1	300	\N	\N	\N	support@lsquared.com	\N	0	\N	\N	0	30	\N	\N	\N	\N	\N	\N	0	\N
\.


--
-- TOC entry 3100 (class 0 OID 247460)
-- Dependencies: 216
-- Data for Name: devicetag; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devicetag (id, name, createdon, createdby, serverid, color, detail) FROM stdin;
2	Tag-1	2025-10-09 07:09:20	1	2		{"isBg":false,"tagColorType":"monochrome"}
3	Tag-2	2025-10-09 07:10:39	1	2		{"isBg":false,"tagColorType":"monochrome"}
\.


--
-- TOC entry 3102 (class 0 OID 247468)
-- Dependencies: 218
-- Data for Name: devicetagassociation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devicetagassociation (id, deviceid, tagid) FROM stdin;
2	8	2
3	17	2
4	107	3
5	18	2
6	19	2
7	20	2
8	21	2
9	22	2
10	23	2
11	24	2
12	25	2
13	26	2
14	9	2
15	27	2
16	28	2
17	29	2
18	30	2
19	31	2
20	32	2
21	33	2
22	34	2
23	35	2
24	36	2
25	10	2
26	37	2
27	38	2
28	39	2
29	40	2
30	41	2
31	42	2
32	43	2
33	44	2
34	45	2
35	46	2
36	11	2
37	47	2
38	48	2
39	49	2
40	50	2
41	51	2
42	52	2
43	53	2
44	54	2
45	55	2
46	56	2
47	12	2
48	57	2
49	58	3
50	59	3
51	60	3
52	61	3
53	62	3
54	63	3
55	64	3
56	65	3
57	66	3
58	13	2
59	67	3
60	68	3
61	69	3
62	70	3
63	71	3
64	72	3
65	73	3
66	74	3
67	75	3
68	76	3
69	14	2
70	77	3
71	78	3
72	79	3
73	80	3
74	81	3
75	82	3
76	83	3
77	84	3
78	85	3
79	86	3
80	15	2
81	87	3
82	88	3
83	89	3
84	90	3
85	91	3
86	92	3
87	93	3
88	94	3
89	95	3
90	96	3
91	16	2
92	97	3
93	98	3
94	99	3
95	100	3
96	101	3
97	102	3
98	103	3
99	104	3
100	105	3
101	106	3
\.


--
-- TOC entry 3104 (class 0 OID 247473)
-- Dependencies: 220
-- Data for Name: flassignment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.flassignment (id, name, layoutid, createdon, createdby, approvedon, approvedby, editedon, editedby, startdate, enddate, iscustom, isapproved, isconflict, isforever) FROM stdin;
5	Test Assignment	5	2025-10-09 06:53:38	1	2025-10-09 06:53:38	1	\N	\N	2025-10-09 00:00:00	2030-10-09 23:59:59	0	1	0	0
6	8 Frame Layout-1759992802	5	2025-10-09 06:56:10	1	2025-10-09 06:56:10	1	\N	\N	2025-10-09 00:00:00	2030-10-09 23:59:59	\N	1	0	0
\.


--
-- TOC entry 3106 (class 0 OID 247480)
-- Dependencies: 222
-- Data for Name: fldeviceassociation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fldeviceassociation (id, assignmentid, deviceid, devicegroupid, assignedvia) FROM stdin;
13	6	8	0	1
14	6	9	0	1
15	6	10	0	1
16	6	11	0	1
17	6	12	0	1
18	6	13	0	1
19	6	14	0	1
20	6	15	0	1
21	6	16	0	1
22	6	17	0	1
23	6	18	0	1
24	6	19	0	1
25	6	20	0	1
26	6	21	0	1
27	6	22	0	1
28	6	23	0	1
29	6	24	0	1
30	6	25	0	1
31	6	26	0	1
32	6	27	0	1
33	6	28	0	1
34	6	29	0	1
35	6	30	0	1
36	6	31	0	1
37	6	32	0	1
38	6	33	0	1
39	6	34	0	1
40	6	35	0	1
41	6	36	0	1
42	6	37	0	1
43	6	38	0	1
44	6	39	0	1
45	6	40	0	1
46	6	41	0	1
47	6	42	0	1
48	6	43	0	1
49	6	44	0	1
50	6	45	0	1
51	6	46	0	1
52	6	47	0	1
53	6	48	0	1
54	6	49	0	1
55	6	50	0	1
56	6	51	0	1
57	6	52	0	1
58	6	53	0	1
59	6	54	0	1
60	6	55	0	1
61	6	56	0	1
62	6	57	0	1
63	6	58	0	1
64	6	59	0	1
65	6	60	0	1
66	6	61	0	1
67	6	62	0	1
68	6	63	0	1
69	6	64	0	1
70	6	65	0	1
71	6	66	0	1
72	6	67	0	1
73	6	68	0	1
74	6	69	0	1
75	6	70	0	1
76	6	71	0	1
77	6	72	0	1
78	6	73	0	1
79	6	74	0	1
80	6	75	0	1
81	6	76	0	1
82	6	77	0	1
83	6	78	0	1
84	6	79	0	1
85	6	80	0	1
86	6	81	0	1
87	6	82	0	1
88	6	83	0	1
89	6	84	0	1
90	6	85	0	1
91	6	86	0	1
92	6	87	0	1
93	6	88	0	1
94	6	89	0	1
95	6	90	0	1
96	6	91	0	1
97	6	92	0	1
98	6	93	0	1
99	6	94	0	1
100	6	95	0	1
101	6	96	0	1
102	6	97	0	1
103	6	98	0	1
104	6	99	0	1
105	6	100	0	1
106	6	101	0	1
107	6	102	0	1
108	6	103	0	1
109	6	104	0	1
110	6	105	0	1
111	6	106	0	1
112	6	107	0	1
\.


--
-- TOC entry 3108 (class 0 OID 247485)
-- Dependencies: 224
-- Data for Name: framelayout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.framelayout (id, name, createdon, createdby, approvedon, approvedby, editedon, editedby, width, height, isapproved, bgcolor, serverid, orientation, thumbversion, oncecompleted, layoutbgtype, defaultframeid) FROM stdin;
5	8 Frame Layout-1759992802	2025-10-09 06:53:22	1	2025-10-09 06:53:22	1	\N	\N	1920	1080	1	#000000	2	l	1759992802	1	monochrome	13
\.


--
-- TOC entry 3110 (class 0 OID 247494)
-- Dependencies: 226
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schedule (id, name, createdon, createdby, approvedon, approvedby, editedon, editedby, startdate, enddate, iscustom, isapproved, isactive, iscompleted, schedulegroupid, serverid, oncecompleted, isconflict, isforever, priority, istrainingmode, type, detail, asanataskchangeon, asanaattachid, asanataskid) FROM stdin;
44	Schedule-1	2025-10-09 07:05:34	1	2025-10-09 07:05:35	1	\N	\N	2025-10-09 00:00:00	2025-10-16 23:59:59	0	1	1	1	0	2	1	0	0	1	0	0		\N	0	0
\.


--
-- TOC entry 3112 (class 0 OID 247515)
-- Dependencies: 228
-- Data for Name: schedulecontentassociation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schedulecontentassociation (id, scheduleid, contentid, duration, sortorder, fullscreen, sound, typ, userid, scaling, caption) FROM stdin;
287	44	111	9.00	0	0	0	Image	1	fit	0
288	44	110	9.00	1	0	0	Image	1	fit	0
\.


--
-- TOC entry 3114 (class 0 OID 247523)
-- Dependencies: 230
-- Data for Name: scheduledeviceassociation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.scheduledeviceassociation (scheduleid, deviceid, devicegroupid, sortorder, tagid, frameid, layoutid, assignmentids, searchid, dvwid, id) FROM stdin;
44	8	0	\N	0	13	5	6	0	\N	397
44	17	0	\N	0	13	5	6	0	\N	398
44	107	0	\N	0	13	5	6	0	\N	399
44	18	0	\N	0	13	5	6	0	\N	400
44	19	0	\N	0	13	5	6	0	\N	401
44	20	0	\N	0	13	5	6	0	\N	402
44	21	0	\N	0	13	5	6	0	\N	403
44	22	0	\N	0	13	5	6	0	\N	404
44	23	0	\N	0	13	5	6	0	\N	405
44	24	0	\N	0	13	5	6	0	\N	406
44	25	0	\N	0	13	5	6	0	\N	407
44	26	0	\N	0	13	5	6	0	\N	408
44	9	0	\N	0	13	5	6	0	\N	409
44	27	0	\N	0	13	5	6	0	\N	410
44	28	0	\N	0	13	5	6	0	\N	411
44	29	0	\N	0	13	5	6	0	\N	412
44	30	0	\N	0	13	5	6	0	\N	413
44	31	0	\N	0	13	5	6	0	\N	414
44	32	0	\N	0	13	5	6	0	\N	415
44	33	0	\N	0	13	5	6	0	\N	416
44	34	0	\N	0	13	5	6	0	\N	417
44	35	0	\N	0	13	5	6	0	\N	418
44	36	0	\N	0	13	5	6	0	\N	419
44	10	0	\N	0	13	5	6	0	\N	420
44	37	0	\N	0	13	5	6	0	\N	421
44	38	0	\N	0	13	5	6	0	\N	422
44	39	0	\N	0	13	5	6	0	\N	423
44	40	0	\N	0	13	5	6	0	\N	424
44	41	0	\N	0	13	5	6	0	\N	425
44	42	0	\N	0	13	5	6	0	\N	426
44	43	0	\N	0	13	5	6	0	\N	427
44	44	0	\N	0	13	5	6	0	\N	428
44	45	0	\N	0	13	5	6	0	\N	429
44	46	0	\N	0	13	5	6	0	\N	430
44	11	0	\N	0	13	5	6	0	\N	431
44	47	0	\N	0	13	5	6	0	\N	432
44	48	0	\N	0	13	5	6	0	\N	433
44	49	0	\N	0	13	5	6	0	\N	434
44	50	0	\N	0	13	5	6	0	\N	435
44	51	0	\N	0	13	5	6	0	\N	436
44	52	0	\N	0	13	5	6	0	\N	437
44	53	0	\N	0	13	5	6	0	\N	438
44	54	0	\N	0	13	5	6	0	\N	439
44	55	0	\N	0	13	5	6	0	\N	440
44	56	0	\N	0	13	5	6	0	\N	441
44	12	0	\N	0	13	5	6	0	\N	442
44	57	0	\N	0	13	5	6	0	\N	443
44	58	0	\N	0	13	5	6	0	\N	444
44	59	0	\N	0	13	5	6	0	\N	445
44	60	0	\N	0	13	5	6	0	\N	446
44	61	0	\N	0	13	5	6	0	\N	447
44	62	0	\N	0	13	5	6	0	\N	448
44	63	0	\N	0	13	5	6	0	\N	449
44	64	0	\N	0	13	5	6	0	\N	450
44	65	0	\N	0	13	5	6	0	\N	451
44	66	0	\N	0	13	5	6	0	\N	452
44	13	0	\N	0	13	5	6	0	\N	453
44	67	0	\N	0	13	5	6	0	\N	454
44	68	0	\N	0	13	5	6	0	\N	455
44	69	0	\N	0	13	5	6	0	\N	456
44	70	0	\N	0	13	5	6	0	\N	457
44	71	0	\N	0	13	5	6	0	\N	458
44	72	0	\N	0	13	5	6	0	\N	459
44	73	0	\N	0	13	5	6	0	\N	460
44	74	0	\N	0	13	5	6	0	\N	461
44	75	0	\N	0	13	5	6	0	\N	462
44	76	0	\N	0	13	5	6	0	\N	463
44	14	0	\N	0	13	5	6	0	\N	464
44	77	0	\N	0	13	5	6	0	\N	465
44	78	0	\N	0	13	5	6	0	\N	466
44	79	0	\N	0	13	5	6	0	\N	467
44	80	0	\N	0	13	5	6	0	\N	468
44	81	0	\N	0	13	5	6	0	\N	469
44	82	0	\N	0	13	5	6	0	\N	470
44	83	0	\N	0	13	5	6	0	\N	471
44	84	0	\N	0	13	5	6	0	\N	472
44	85	0	\N	0	13	5	6	0	\N	473
44	86	0	\N	0	13	5	6	0	\N	474
44	15	0	\N	0	13	5	6	0	\N	475
44	87	0	\N	0	13	5	6	0	\N	476
44	88	0	\N	0	13	5	6	0	\N	477
44	89	0	\N	0	13	5	6	0	\N	478
44	90	0	\N	0	13	5	6	0	\N	479
44	91	0	\N	0	13	5	6	0	\N	480
44	92	0	\N	0	13	5	6	0	\N	481
44	93	0	\N	0	13	5	6	0	\N	482
44	94	0	\N	0	13	5	6	0	\N	483
44	95	0	\N	0	13	5	6	0	\N	484
44	96	0	\N	0	13	5	6	0	\N	485
44	16	0	\N	0	13	5	6	0	\N	486
44	97	0	\N	0	13	5	6	0	\N	487
44	98	0	\N	0	13	5	6	0	\N	488
44	99	0	\N	0	13	5	6	0	\N	489
44	100	0	\N	0	13	5	6	0	\N	490
44	101	0	\N	0	13	5	6	0	\N	491
44	102	0	\N	0	13	5	6	0	\N	492
44	103	0	\N	0	13	5	6	0	\N	493
44	104	0	\N	0	13	5	6	0	\N	494
44	105	0	\N	0	13	5	6	0	\N	495
44	106	0	\N	0	13	5	6	0	\N	496
\.


--
-- TOC entry 3116 (class 0 OID 247533)
-- Dependencies: 232
-- Data for Name: schedulepermission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schedulepermission (id, scheduleid, usergroupid) FROM stdin;
64	31	0
66	29	0
71	32	0
132	37	0
135	39	0
136	40	0
155	41	0
156	43	0
157	44	0
54	30	0
\.


--
-- TOC entry 3120 (class 0 OID 247632)
-- Dependencies: 236
-- Data for Name: timezone; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.timezone (id, label, timezone, "offset", name) FROM stdin;
1	(UTC-11:00) Samoa Standard Time	Pacific/Pago_Pago	-11.00	SST
2	(UTC-11:00) Niue Time	Pacific/Niue	-11.00	NUT
3	(UTC-10:00) Hawaii-Aleutian Standard Time	Pacific/Honolulu	-10.00	HAST
4	(UTC-9:30) Marquesas Islands Time	Pacific/Marquesas	-9.50	MIT
5	(UTC-9:00) Alaska Standard Time	America/Anchorage	-9.00	AKST
6	(UTC-9:00) Gambier Islands Time	Pacific/Gambier	-9.00	GAMT
7	(UTC-8:00) Pacific Standard Time	America/Los_Angeles	-8.00	PST
8	(UTC-8:00) Pacific Standard Time	America/Vancouver	-8.00	PST
9	(UTC-8:00) Pitcairn Standard Time	Pacific/Pitcairn	-8.00	PST
10	(UTC-7:00) Mountain Standard Time	America/Denver	-7.00	MST
11	(UTC-7:00) Mountain Standard Time	America/Edmonton	-7.00	MST
12	(UTC-7:00) Mountain Standard Time	America/Phoenix	-7.00	MST
13	(UTC-6:00) Central Standard Time	America/Chicago	-6.00	CST
14	(UTC-6:00) Central Standard Time	America/Winnipeg	-6.00	CST
15	(UTC-6:00) Easter Island Standard Time	Pacific/Easter	-6.00	EAST
16	(UTC-6:00) Galápagos Time	Pacific/Galapagos	-6.00	GALT
17	(UTC-5:00) Eastern Standard Time	America/New_York	-5.00	EST
18	(UTC-5:00) Eastern Standard Time	America/Toronto	-5.00	EST
19	(UTC-5:00) Colombia Time	America/Bogota	-5.00	COT
20	(UTC-5:00) Cuba Standard Time	America/Havana	-5.00	CST
21	(UTC-5:00) Peru Time	America/Lima	-5.00	PET
22	(UTC-4:30) Venezuela Time	America/Caracas	-4.50	VET
23	(UTC-4:00) Atlantic Standard Time	America/Halifax	-4.00	AST
24	(UTC-4:00) Atlantic Standard Time	America/Barbados	-4.00	AST
25	(UTC-4:00) Bolivia Time	America/La_Paz	-4.00	BOT
26	(UTC-4:00) Paraguay Time	America/Asuncion	-4.00	PYT
27	(UTC-3:30) Newfoundland Standard Time	America/St_Johns	-3.50	NST
28	(UTC-3:00) Argentina Time	America/Argentina/Buenos_Aires	-3.00	ART
29	(UTC-3:00) Argentina Time	America/Buenos_Aires	-3.00	ART
30	(UTC-3:00) Brasilia Time	America/Sao_Paulo	-3.00	BRT
31	(UTC-3:00) Uruguay Time	America/Montevideo	-3.00	UYT
32	(UTC-3:00) French Guiana Time	America/Cayenne	-3.00	GFT
33	(UTC-2:00) South Georgia Time	Atlantic/South_Georgia	-2.00	GST
34	(UTC-1:00) Azores Standard Time	Atlantic/Azores	-1.00	AZOT
35	(UTC-1:00) Cape Verde Time	Atlantic/Cape_Verde	-1.00	CVT
36	(UTC) Coordinated Universal Time	Etc/UTC	0.00	UTC
37	(UTC 0:00) Greenwich Mean Time	Europe/London	0.00	GMT
38	(UTC 0:00) Greenwich Mean Time	Africa/Accra	0.00	GMT
39	(UTC 0:00) Greenwich Mean Time	Atlantic/Reykjavik	0.00	GMT
40	(UTC+1:00) Central European Time	Europe/Paris	1.00	CET
41	(UTC+1:00) Central European Time	Europe/Berlin	1.00	CET
42	(UTC+1:00) West Africa Time	Africa/Lagos	1.00	WAT
43	(UTC+2:00) Eastern European Time	Europe/Athens	2.00	EET
44	(UTC+2:00) Eastern European Time	Europe/Bucharest	2.00	EET
45	(UTC+2:00) South Africa Standard Time	Africa/Johannesburg	2.00	SAST
46	(UTC+2:00) Israel Standard Time	Asia/Jerusalem	2.00	IST
47	(UTC+3:00) Moscow Standard Time	Europe/Moscow	3.00	MSK
48	(UTC+3:00) Arabian Standard Time	Asia/Riyadh	3.00	AST
49	(UTC+3:00) East Africa Time	Africa/Nairobi	3.00	EAT
50	(UTC+3:30) Iran Standard Time	Asia/Tehran	3.50	IRST
51	(UTC+4:00) Gulf Standard Time	Asia/Dubai	4.00	GST
52	(UTC+4:00) Seychelles Time	Indian/Mahe	4.00	SCT
53	(UTC+4:00) Mauritius Time	Indian/Mauritius	4.00	MUT
54	(UTC+4:30) Afghanistan Time	Asia/Kabul	4.50	AFT
55	(UTC+5:00) Pakistan Standard Time	Asia/Karachi	5.00	PKT
56	(UTC+5:00) Tajikistan Time	Asia/Dushanbe	5.00	TJT
57	(UTC+5:30) India Standard Time	Asia/Kolkata	5.50	IST
58	(UTC+5:30) Sri Lanka Standard Time	Asia/Colombo	5.50	SLST
59	(UTC+5:45) Nepal Time	Asia/Kathmandu	5.75	NPT
60	(UTC+6:00) Bangladesh Standard Time	Asia/Dhaka	6.00	BST
61	(UTC+6:00) Bhutan Time	Asia/Thimphu	6.00	BTT
62	(UTC+6:30) Cocos Islands Time	Indian/Cocos	6.50	CCT
63	(UTC+6:30) Myanmar Time	Asia/Yangon	6.50	MMT
64	(UTC+7:00) Indochina Time	Asia/Bangkok	7.00	ICT
65	(UTC+7:00) Krasnoyarsk Time	Asia/Krasnoyarsk	7.00	KRAT
66	(UTC+8:00) China Standard Time	Asia/Shanghai	8.00	CST
67	(UTC+8:00) Australian Western Standard Time	Australia/Perth	8.00	AWST
68	(UTC+8:00) Singapore Standard Time	Asia/Singapore	8.00	SGT
69	(UTC+8:45) Australian Central Western Standard Time	Australia/Eucla	8.75	ACWST
70	(UTC+9:00) Japan Standard Time	Asia/Tokyo	9.00	JST
71	(UTC+9:00) Korea Standard Time	Asia/Seoul	9.00	KST
72	(UTC+9:30) Australian Central Standard Time	Australia/Darwin	9.50	ACST
73	(UTC+10:00) Australian Eastern Standard Time	Australia/Sydney	10.00	AEST
74	(UTC+10:00) Vladivostok Time	Asia/Vladivostok	10.00	VLAT
75	(UTC+10:30) Lord Howe Standard Time	Australia/Lord_Howe	10.50	LHST
76	(UTC+11:00) Solomon Islands Time	Pacific/Guadalcanal	11.00	SBT
77	(UTC+12:00) New Zealand Standard Time	Pacific/Auckland	12.00	NZST
78	(UTC+12:00) Fiji Standard Time	Pacific/Fiji	12.00	FJT
79	(UTC+12:45) Chatham Standard Time	Pacific/Chatham	12.75	CHAST
80	(UTC+13:00) Tonga Time	Pacific/Tongatapu	13.00	TOT
81	(UTC+14:00) Line Islands Time	Pacific/Kiritimati	14.00	LINT
\.


--
-- TOC entry 3118 (class 0 OID 247538)
-- Dependencies: 234
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."user" (id, fname, lname, dp, email, pwd, createdon, createdby, isverified, istourvisited, timezone, lang, code, islpopen, istreeopen, issplitv, ispin, ispopup, deviceview, contentdisplaysize, issuperadmin, isactive, isapproved, partnerid, changepwd, ispwdlinkactive, mobileno, deviceid, devicearn, ishubuser, iscpuser, ip, userdetail, login_attempts, islocked, login_wrong_attempt_time, resetpwd_key, is2faactive, "2fasecret", isoktauser, content_scaling_schedule, sctype, schedule_default_date_range, dmbsort, theme, contentview, isdf_treeopen, sfdl, sfop, templateview, sdtf, dmb_templateview, dmb_deviceview, dmb_theme) FROM stdin;
1	Vijay	L Squared		vijay.dohare@lsquared.com	\N	2019-05-06 00:00:00	0	1	0	America/Toronto	en_US	0	0	1	1	0	1	t	n	\N	1	1	\N	0	0	\N	\N	\N	1	0	\N	\N	0	0	\N	\N	0	\N	0	fit	-1	w	a	df	t	1	1	1	t	0	l	l	df
\.


--
-- TOC entry 3207 (class 0 OID 0)
-- Dependencies: 203
-- Name: contentlibrary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contentlibrary_id_seq', 112, true);


--
-- TOC entry 3208 (class 0 OID 0)
-- Dependencies: 205
-- Name: contentpermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contentpermission_id_seq', 270, true);


--
-- TOC entry 3209 (class 0 OID 0)
-- Dependencies: 207
-- Name: device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.device_id_seq', 107, true);


--
-- TOC entry 3210 (class 0 OID 0)
-- Dependencies: 209
-- Name: deviceextraips_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.deviceextraips_id_seq', 1, true);


--
-- TOC entry 3211 (class 0 OID 0)
-- Dependencies: 239
-- Name: devicemigrationhistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devicemigrationhistory_id_seq', 1, false);


--
-- TOC entry 3212 (class 0 OID 0)
-- Dependencies: 240
-- Name: devicepermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devicepermission_id_seq', 106, true);


--
-- TOC entry 3213 (class 0 OID 0)
-- Dependencies: 211
-- Name: deviceproperties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.deviceproperties_id_seq', 1, true);


--
-- TOC entry 3214 (class 0 OID 0)
-- Dependencies: 213
-- Name: devicepropertiesassociation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devicepropertiesassociation_id_seq', 101, true);


--
-- TOC entry 3215 (class 0 OID 0)
-- Dependencies: 215
-- Name: devicesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devicesetting_id_seq', 107, true);


--
-- TOC entry 3216 (class 0 OID 0)
-- Dependencies: 217
-- Name: devicetag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devicetag_id_seq', 3, true);


--
-- TOC entry 3217 (class 0 OID 0)
-- Dependencies: 219
-- Name: devicetagassociation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devicetagassociation_id_seq', 101, true);


--
-- TOC entry 3218 (class 0 OID 0)
-- Dependencies: 221
-- Name: flassignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.flassignment_id_seq', 6, true);


--
-- TOC entry 3219 (class 0 OID 0)
-- Dependencies: 223
-- Name: fldeviceassociation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fldeviceassociation_id_seq', 112, true);


--
-- TOC entry 3220 (class 0 OID 0)
-- Dependencies: 225
-- Name: framelayout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.framelayout_id_seq', 5, true);


--
-- TOC entry 3221 (class 0 OID 0)
-- Dependencies: 227
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schedule_id_seq', 44, true);


--
-- TOC entry 3222 (class 0 OID 0)
-- Dependencies: 229
-- Name: schedulecontentassociation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schedulecontentassociation_id_seq', 288, true);


--
-- TOC entry 3223 (class 0 OID 0)
-- Dependencies: 231
-- Name: scheduledeviceassociation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scheduledeviceassociation_id_seq', 496, true);


--
-- TOC entry 3224 (class 0 OID 0)
-- Dependencies: 233
-- Name: schedulepermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schedulepermission_id_seq', 157, true);


--
-- TOC entry 3225 (class 0 OID 0)
-- Dependencies: 237
-- Name: timezone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.timezone_id_seq', 81, true);


--
-- TOC entry 3226 (class 0 OID 0)
-- Dependencies: 235
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_id_seq', 13, true);


--
-- TOC entry 2916 (class 2606 OID 247593)
-- Name: contentlibrary contentlibrary_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentlibrary
    ADD CONSTRAINT contentlibrary_pkey PRIMARY KEY (id);


--
-- TOC entry 2918 (class 2606 OID 247595)
-- Name: contentpermission contentpermission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentpermission
    ADD CONSTRAINT contentpermission_pkey PRIMARY KEY (id);


--
-- TOC entry 2920 (class 2606 OID 247597)
-- Name: device device_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (id);


--
-- TOC entry 2926 (class 2606 OID 247599)
-- Name: deviceextraips deviceextraips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deviceextraips
    ADD CONSTRAINT deviceextraips_pkey PRIMARY KEY (id);


--
-- TOC entry 2957 (class 2606 OID 247647)
-- Name: devicemigrationhistory devicemigrationhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicemigrationhistory
    ADD CONSTRAINT devicemigrationhistory_pkey PRIMARY KEY (id);


--
-- TOC entry 2959 (class 2606 OID 247675)
-- Name: devicepermission devicepermission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicepermission
    ADD CONSTRAINT devicepermission_pkey PRIMARY KEY (id);


--
-- TOC entry 2928 (class 2606 OID 247601)
-- Name: deviceproperties deviceproperties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deviceproperties
    ADD CONSTRAINT deviceproperties_pkey PRIMARY KEY (id);


--
-- TOC entry 2930 (class 2606 OID 247603)
-- Name: devicepropertiesassociation devicepropertiesassociation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicepropertiesassociation
    ADD CONSTRAINT devicepropertiesassociation_pkey PRIMARY KEY (id);


--
-- TOC entry 2932 (class 2606 OID 247605)
-- Name: devicesetting devicesetting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicesetting
    ADD CONSTRAINT devicesetting_pkey PRIMARY KEY (id);


--
-- TOC entry 2934 (class 2606 OID 247607)
-- Name: devicetag devicetag_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicetag
    ADD CONSTRAINT devicetag_pkey PRIMARY KEY (id);


--
-- TOC entry 2936 (class 2606 OID 247609)
-- Name: devicetagassociation devicetagassociation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devicetagassociation
    ADD CONSTRAINT devicetagassociation_pkey PRIMARY KEY (id);


--
-- TOC entry 2938 (class 2606 OID 247611)
-- Name: flassignment flassignment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flassignment
    ADD CONSTRAINT flassignment_pkey PRIMARY KEY (id);


--
-- TOC entry 2941 (class 2606 OID 247613)
-- Name: fldeviceassociation fldeviceassociation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fldeviceassociation
    ADD CONSTRAINT fldeviceassociation_pkey PRIMARY KEY (id);


--
-- TOC entry 2943 (class 2606 OID 247615)
-- Name: framelayout framelayout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framelayout
    ADD CONSTRAINT framelayout_pkey PRIMARY KEY (id);


--
-- TOC entry 2945 (class 2606 OID 247617)
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 2947 (class 2606 OID 247619)
-- Name: schedulecontentassociation schedulecontentassociation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedulecontentassociation
    ADD CONSTRAINT schedulecontentassociation_pkey PRIMARY KEY (id);


--
-- TOC entry 2949 (class 2606 OID 247679)
-- Name: scheduledeviceassociation scheduledeviceassociation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduledeviceassociation
    ADD CONSTRAINT scheduledeviceassociation_pkey PRIMARY KEY (id);


--
-- TOC entry 2951 (class 2606 OID 247621)
-- Name: schedulepermission schedulepermission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedulepermission
    ADD CONSTRAINT schedulepermission_pkey PRIMARY KEY (id);


--
-- TOC entry 2955 (class 2606 OID 247639)
-- Name: timezone timezone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timezone
    ADD CONSTRAINT timezone_pkey PRIMARY KEY (id);


--
-- TOC entry 2953 (class 2606 OID 247623)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2939 (class 1259 OID 247624)
-- Name: fld_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fld_idx ON public.fldeviceassociation USING btree (deviceid, assignmentid);


--
-- TOC entry 2921 (class 1259 OID 247625)
-- Name: idx_hardwareid_isactive; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hardwareid_isactive ON public.device USING btree (hardwareid, isactive);


--
-- TOC entry 2922 (class 1259 OID 247626)
-- Name: idx_hardwareid_transformed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hardwareid_transformed ON public.device USING btree (lower(replace((hardwareid)::text, ':'::text, ''::text)));


--
-- TOC entry 2923 (class 1259 OID 247627)
-- Name: idx_isactive; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_isactive ON public.device USING btree (isactive);


--
-- TOC entry 2924 (class 1259 OID 247628)
-- Name: idx_isactive_1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_isactive_1 ON public.device USING btree (hardwareid) WHERE (isactive = 1);


-- Completed on 2025-10-09 20:44:22

--
-- PostgreSQL database dump complete
--

