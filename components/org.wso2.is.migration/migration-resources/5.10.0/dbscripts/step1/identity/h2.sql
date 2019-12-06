ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD COLUMN TOKEN_BINDING_REF VARCHAR(32) DEFAULT 'NONE';

ALTER TABLE IDN_ASSOCIATED_ID ADD COLUMN ASSOCIATION_ID CHAR(36) NOT NULL;

ALTER TABLE SP_APP
  ADD COLUMN (
      UUID CHAR(36),
      IMAGE_URL VARCHAR(1024),
      ACCESS_URL VARCHAR(1024));

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_UUID_CONSTRAINT UNIQUE(UUID);

ALTER TABLE IDP
  ADD COLUMN (
      IMAGE_URL VARCHAR(1024),
      UUID CHAR(36));

ALTER TABLE IDP ADD CONSTRAINT IDP_UUID_CONSTRAINT UNIQUE (UUID);

ALTER TABLE IF EXISTS IDN_CONFIG_FILE ADD COLUMN IF NOT EXISTS NAME VARCHAR(255) NULL;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_TOKEN_BINDING (
    TOKEN_ID VARCHAR(255),
    TOKEN_BINDING_TYPE VARCHAR(32),
    TOKEN_BINDING_REF VARCHAR(32),
    TOKEN_BINDING_VALUE VARCHAR(1024),
    TENANT_ID INTEGER DEFAULT -1,
    PRIMARY KEY (TOKEN_ID),
    FOREIGN KEY (TOKEN_ID) REFERENCES IDN_OAUTH2_ACCESS_TOKEN(TOKEN_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IDN_FEDERATED_AUTH_SESSION_MAPPING (
	IDP_SESSION_ID VARCHAR(255) NOT NULL,
	SESSION_ID VARCHAR(255) NOT NULL,
	IDP_NAME VARCHAR(255) NOT NULL,
	AUTHENTICATOR_ID VARCHAR(255),
	PROTOCOL_TYPE VARCHAR(255),
	TIME_CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(IDP_SESSION_ID)
);

-- IDN_OAUTH2_TOKEN_BINDING --
CREATE INDEX IDX_IDN_AUTH_BIND ON IDN_OAUTH2_TOKEN_BINDING (TOKEN_BINDING_REF);

-- IDN_ASSOCIATED_ID --
CREATE INDEX IDX_AI_DN_UN_AI ON IDN_ASSOCIATED_ID(DOMAIN_NAME, USER_NAME, ASSOCIATION_ID);

CREATE INDEX IDX_AT_CKID_AU_TID_UD_TSH_TS ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TENANT_ID, USER_DOMAIN, TOKEN_SCOPE_HASH, TOKEN_STATE);

-- IDN_FEDERATED_AUTH_SESSION_MAPPING --
CREATE INDEX IDX_FEDERATED_AUTH_SESSION_ID ON IDN_FEDERATED_AUTH_SESSION_MAPPING (SESSION_ID);
