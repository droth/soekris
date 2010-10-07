sql statements::
CREATE TABLE calendars (
  id varchar(250) NOT NULL,
  type varchar(30) NOT NULL,
  name varchar(255) default '',
  domain varchar(128) default '',
  created_on timestamp,
  last_modified_on timestamp,
  ical_raw text NOT NULL,
  CONSTRAINT PK_calendars PRIMARY KEY (id)
) 

CREATE TABLE calendar_owners (
  calendar_id varchar(250) NOT NULL,
  owner_name varchar(128) NOT NULL,
  CONSTRAINT PK_calendar_owners PRIMARY KEY (calendar_id, owner_name)
);

CREATE TABLE calendar_readers (
  calendar_id varchar(250) NOT NULL,
  reader_name varchar(128) NOT NULL,
  CONSTRAINT PK_calendar_readers PRIMARY KEY (calendar_id, reader_name)
);

CREATE TABLE calendar_writers (
  calendar_id varchar(250) NOT NULL,
  writer_name varchar(128) NOT NULL,
  CONSTRAINT PK_calendar_writers PRIMARY KEY (calendar_id, writer_name)
);

CREATE SEQUENCE events_seq START 1;

CREATE TABLE events (
  id integer DEFAULT nextval('events_seq')NOT NULL,
  event_id varchar(250) NOT NULL,
  calendar_id varchar(250) NOT NULL,
  domain varchar(128) default '',
  evt_start timestamp,
  evt_end timestamp,
  isAllDay varchar(10) NOT NULL CHECK (isAllDay IN ('YES', 'NO')),
  isRecurring varchar(10) NOT NULL CHECK (isRecurring IN ('YES', 'NO')),
  isTask varchar(10) NOT NULL CHECK (isTask IN ('YES', 'NO')),
  isHoliday varchar(10) NOT NULL CHECK (isHoliday IN ('YES', 'NO')),
  priority smallint default 5,  -- default NORMAL priority
  created_on timestamp,
  last_modified_on timestamp,
  ical_raw text NOT NULL,
  CONSTRAINT PK_events PRIMARY KEY (id),
  CONSTRAINT event_per_calendar UNIQUE (event_id, calendar_id)
) ;

CREATE TABLE event_parent_calendars (
  event_key integer NOT NULL,
  parent_calendar_id varchar(250) NOT NULL,
  CONSTRAINT PK_event_parent_calendars PRIMARY KEY (event_key, parent_calendar_id)
) ;

CREATE TABLE event_owners (
  event_key integer NOT NULL,
  owner_name varchar(128) NOT NULL,
  CONSTRAINT PK_event_owner PRIMARY KEY (event_key, owner_name)
) ;

CREATE TABLE event_readers (
  event_key integer NOT NULL,
  reader_name varchar(128) NOT NULL,
  CONSTRAINT PK_event_reader PRIMARY KEY (event_key, reader_name)
) ;

CREATE TABLE event_writers (
  event_key integer NOT NULL,
  writer_name varchar(128) NOT NULL,
  CONSTRAINT PK_event_writers PRIMARY KEY (event_key, writer_name)
) 




CREATE INDEX IDX_calenders_type ON calendars (type);
CREATE INDEX IDX_events_recurring ON events (isRecurring);
CREATE INDEX IDX_events_task ON events (isTask);
CREATE INDEX IDX_events_holiday ON events (isHoliday);
CREATE INDEX IDX_events_start ON events (evt_start);
CREATE INDEX IDX_events_end ON events (evt_end);


GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON calendar TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON calendar_owners TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON calendar_readers TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON calendar_writers TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON events TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON event_parent_calendars TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON event_owners TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON event_readers TO $calenderUser;
GRANT SELECT,INSERT,DELETE,UPDATE,TRIGGER ON event_writers TO $calenderUser;
