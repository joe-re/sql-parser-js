Start
  = Stmt

Stmt
  = SelectStmt

/* Statements */

SelectStmt
  = _ SelectToken
    _ x:SelectField xs:SelectFieldRest*
    _ FromToken
    _ from:Identifier
    _ where:WhereExpr? {
    return {
      type: "select",
      columns: [x].concat(xs),
      from: from,
      where: where
    };
  }

SelectField "select valid field"
  = Identifier
  / Star

SelectFieldRest
  = _ SeparatorToken _ s:SelectField {
    return s;
  }

WhereExpr "where expression"
  = WhereToken x:LogicExpr xs:LogicExprRest* {
    return {
      conditions: [x].concat(xs)
    };
  }

LogicExpr
  = _ "(" _ x:LogicExpr xs:LogicExprRest* _ ")" _ {
    return [x].concat(xs);
  }
  / _ left:Expr _ op:Operator _ right:Expr _ {
    return {
      left: left,
      op: op,
      right: right
    };
  }

LogicExprRest
  = _ j:Joiner _ l:LogicExpr {
    return {
      joiner: j,
      expression: l
    };
  }

Joiner "joiner"
  = OrToken  { return "Or";  }
  / AndToken { return "And"; }

Operator
  = "<>"       { return "Different"; }
  / "="        { return "Equal";     }
  / LikeToken  { return "Like";      }

/* Expressions */

Expr
  = Float
  / Integer
  / Identifier
  / String

Integer "integer"
  = n:[0-9]+ {
    return parseInt(n.join(""));
  }

Float "float"
  = left:Integer "." right:Integer {
    return parseFloat([
      left.toString(),
      right.toString()
    ].join("."));
  }

String "string"
  = "'" str:ValidStringChar* "'" {
    return str.join("");
  }

ValidStringChar
  = !"'" c:. {
    return c;
  }

/* Tokens */

SelectToken
  = "SELECT"i !IdentRest

SeparatorToken
  = ","

FromToken
  = "FROM"i !IdentRest

WhereToken
  = "WHERE"i !IdentRest

LikeToken
  = "LIKE"i !IdentRest

OrToken
  = "OR"i !IdentRest

AndToken
  = "AND"i !IdentRest

/* Charactors */
Dot    = '.'
Comma  = ','
Star   = '*'
Lparen = '('
Rparen = ')'
Lbrake = '['
Rbrake = ']'

/* Identifier */

Identifier "identifier"
  = !ReservedWord x:IdentStart xs:IdentRest* {
    return x + xs.join('');
  }

IdentStart
  = [a-z_]i

IdentRest
  = [a-z0-9_]i

/* Skip */
_
  = ( WhiteSpace / NewLine )*

NewLine "newline"
  = "\r\n"
  / "\r"
  / "\n"
  / "\u2028"
  / "\u2029"

WhiteSpace "whitespace"
  = " "
  / "\t"
  / "\v"
  / "\f"

/* Resercved Words https://dev.mysql.com/doc/refman/5.7/en/keywords.html */
ACCESSIBLE_KW                    = "ACCESSIBLE"i !IdentRest
ACCOUNT_KW                       = "ACCOUNT"i !IdentRest
ACTION_KW                        = "ACTION"i !IdentRest
ADD_KW                           = "ADD"i !IdentRest
AFTER_KW                         = "AFTER"i !IdentRest
AGAINST_KW                       = "AGAINST"i !IdentRest
AGGREGATE_KW                     = "AGGREGATE"i !IdentRest
ALGORITHM_KW                     = "ALGORITHM"i !IdentRest
ALL_KW                           = "ALL"i !IdentRest
ALTER_KW                         = "ALTER"i !IdentRest
ALWAYS_KW                        = "ALWAYS"i !IdentRest
ANALYSE_KW                       = "ANALYSE"i !IdentRest
ANALYZE_KW                       = "ANALYZE"i !IdentRest
AND_KW                           = "AND"i !IdentRest
ANY_KW                           = "ANY"i !IdentRest
AS_KW                            = "AS"i !IdentRest
ASC_KW                           = "ASC"i !IdentRest
ASCII_KW                         = "ASCII"i !IdentRest
ASENSITIVE_KW                    = "ASENSITIVE"i !IdentRest
AT_KW                            = "AT"i !IdentRest
AUTOEXTEND_SIZE_KW               = "AUTOEXTEND_SIZE"i !IdentRest
AUTO_INCREMENT_KW                = "AUTO_INCREMENT"i !IdentRest
AVG_KW                           = "AVG"i !IdentRest
AVG_ROW_LENGTH_KW                = "AVG_ROW_LENGTH"i !IdentRest
BACKUP_KW                        = "BACKUP"i !IdentRest
BEFORE_KW                        = "BEFORE"i !IdentRest
BEGIN_KW                         = "BEGIN"i !IdentRest
BETWEEN_KW                       = "BETWEEN"i !IdentRest
BIGINT_KW                        = "BIGINT"i !IdentRest
BINARY_KW                        = "BINARY"i !IdentRest
BINLOG_KW                        = "BINLOG"i !IdentRest
BIT_KW                           = "BIT"i !IdentRest
BLOB_KW                          = "BLOB"i !IdentRest
BLOCK_KW                         = "BLOCK"i !IdentRest
BOOL_KW                          = "BOOL"i !IdentRest
BOOLEAN_KW                       = "BOOLEAN"i !IdentRest
BOTH_KW                          = "BOTH"i !IdentRest
BTREE_KW                         = "BTREE"i !IdentRest
BY_KW                            = "BY"i !IdentRest
BYTE_KW                          = "BYTE"i !IdentRest
CACHE_KW                         = "CACHE"i !IdentRest
CALL_KW                          = "CALL"i !IdentRest
CASCADE_KW                       = "CASCADE"i !IdentRest
CASCADED_KW                      = "CASCADED"i !IdentRest
CASE_KW                          = "CASE"i !IdentRest
CATALOG_NAME_KW                  = "CATALOG_NAME"i !IdentRest
CHAIN_KW                         = "CHAIN"i !IdentRest
CHANGE_KW                        = "CHANGE"i !IdentRest
CHANGED_KW                       = "CHANGED"i !IdentRest
CHANNEL_KW                       = "CHANNEL"i !IdentRest
CHAR_KW                          = "CHAR"i !IdentRest
CHARACTER_KW                     = "CHARACTER"i !IdentRest
CHARSET_KW                       = "CHARSET"i !IdentRest
CHECK_KW                         = "CHECK"i !IdentRest
CHECKSUM_KW                      = "CHECKSUM"i !IdentRest
CIPHER_KW                        = "CIPHER"i !IdentRest
CLASS_ORIGIN_KW                  = "CLASS_ORIGIN"i !IdentRest
CLIENT_KW                        = "CLIENT"i !IdentRest
CLOSE_KW                         = "CLOSE"i !IdentRest
COALESCE_KW                      = "COALESCE"i !IdentRest
CODE_KW                          = "CODE"i !IdentRest
COLLATE_KW                       = "COLLATE"i !IdentRest
COLLATION_KW                     = "COLLATION"i !IdentRest
COLUMN_KW                        = "COLUMN"i !IdentRest
COLUMNS_KW                       = "COLUMNS"i !IdentRest
COLUMN_FORMAT_KW                 = "COLUMN_FORMAT"i !IdentRest
COLUMN_NAME_KW                   = "COLUMN_NAME"i !IdentRest
COMMENT_KW                       = "COMMENT"i !IdentRest
COMMIT_KW                        = "COMMIT"i !IdentRest
COMMITTED_KW                     = "COMMITTED"i !IdentRest
COMPACT_KW                       = "COMPACT"i !IdentRest
COMPLETION_KW                    = "COMPLETION"i !IdentRest
COMPRESSED_KW                    = "COMPRESSED"i !IdentRest
COMPRESSION_KW                   = "COMPRESSION"i !IdentRest
CONCURRENT_KW                    = "CONCURRENT"i !IdentRest
CONDITION_KW                     = "CONDITION"i !IdentRest
CONNECTION_KW                    = "CONNECTION"i !IdentRest
CONSISTENT_KW                    = "CONSISTENT"i !IdentRest
CONSTRAINT_KW                    = "CONSTRAINT"i !IdentRest
CONSTRAINT_CATALOG_KW            = "CONSTRAINT_CATALOG"i !IdentRest
CONSTRAINT_NAME_KW               = "CONSTRAINT_NAME"i !IdentRest
CONSTRAINT_SCHEMA_KW             = "CONSTRAINT_SCHEMA"i !IdentRest
CONTAINS_KW                      = "CONTAINS"i !IdentRest
CONTEXT_KW                       = "CONTEXT"i !IdentRest
CONTINUE_KW                      = "CONTINUE"i !IdentRest
CONVERT_KW                       = "CONVERT"i !IdentRest
CPU_KW                           = "CPU"i !IdentRest
CREATE_KW                        = "CREATE"i !IdentRest
CROSS_KW                         = "CROSS"i !IdentRest
CUBE_KW                          = "CUBE"i !IdentRest
CURRENT_KW                       = "CURRENT"i !IdentRest
CURRENT_DATE_KW                  = "CURRENT_DATE"i !IdentRest
CURRENT_TIME_KW                  = "CURRENT_TIME"i !IdentRest
CURRENT_TIMESTAMP_KW             = "CURRENT_TIMESTAMP"i !IdentRest
CURRENT_USER_KW                  = "CURRENT_USER"i !IdentRest
CURSOR_KW                        = "CURSOR"i !IdentRest
CURSOR_NAME_KW                   = "CURSOR_NAME"i !IdentRest
DATA_KW                          = "DATA"i !IdentRest
DATABASE_KW                      = "DATABASE"i !IdentRest
DATABASES_KW                     = "DATABASES"i !IdentRest
DATAFILE_KW                      = "DATAFILE"i !IdentRest
DATE_KW                          = "DATE"i !IdentRest
DATETIME_KW                      = "DATETIME"i !IdentRest
DAY_KW                           = "DAY"i !IdentRest
DAY_HOUR_KW                      = "DAY_HOUR"i !IdentRest
DAY_MICROSECOND_KW               = "DAY_MICROSECOND"i !IdentRest
DAY_MINUTE_KW                    = "DAY_MINUTE"i !IdentRest
DAY_SECOND_KW                    = "DAY_SECOND"i !IdentRest
DEALLOCATE_KW                    = "DEALLOCATE"i !IdentRest
DEC_KW                           = "DEC"i !IdentRest
DECIMAL_KW                       = "DECIMAL"i !IdentRest
DECLARE_KW                       = "DECLARE"i !IdentRest
DEFAULT_KW                       = "DEFAULT"i !IdentRest
DEFAULT_AUTH_KW                  = "DEFAULT_AUTH"i !IdentRest
DEFINER_KW                       = "DEFINER"i !IdentRest
DELAYED_KW                       = "DELAYED"i !IdentRest
DELAY_KEY_WRITE_KW               = "DELAY_KEY_WRITE"i !IdentRest
DELETE_KW                        = "DELETE"i !IdentRest
DESC_KW                          = "DESC"i !IdentRest
DESCRIBE_KW                      = "DESCRIBE"i !IdentRest
DES_KEY_FILE_KW                  = "DES_KEY_FILE"i !IdentRest
DETERMINISTIC_KW                 = "DETERMINISTIC"i !IdentRest
DIAGNOSTICS_KW                   = "DIAGNOSTICS"i !IdentRest
DIRECTORY_KW                     = "DIRECTORY"i !IdentRest
DISABLE_KW                       = "DISABLE"i !IdentRest
DISCARD_KW                       = "DISCARD"i !IdentRest
DISK_KW                          = "DISK"i !IdentRest
DISTINCT_KW                      = "DISTINCT"i !IdentRest
DISTINCTROW_KW                   = "DISTINCTROW"i !IdentRest
DIV_KW                           = "DIV"i !IdentRest
DO_KW                            = "DO"i !IdentRest
DOUBLE_KW                        = "DOUBLE"i !IdentRest
DROP_KW                          = "DROP"i !IdentRest
DUAL_KW                          = "DUAL"i !IdentRest
DUMPFILE_KW                      = "DUMPFILE"i !IdentRest
DUPLICATE_KW                     = "DUPLICATE"i !IdentRest
DYNAMIC_KW                       = "DYNAMIC"i !IdentRest
EACH_KW                          = "EACH"i !IdentRest
ELSE_KW                          = "ELSE"i !IdentRest
ELSEIF_KW                        = "ELSEIF"i !IdentRest
ENABLE_KW                        = "ENABLE"i !IdentRest
ENCLOSED_KW                      = "ENCLOSED"i !IdentRest
ENCRYPTION_KW                    = "ENCRYPTION[e]"i !IdentRest
END_KW                           = "END"i !IdentRest
ENDS_KW                          = "ENDS"i !IdentRest
ENGINE_KW                        = "ENGINE"i !IdentRest
ENGINES_KW                       = "ENGINES"i !IdentRest
ENUM_KW                          = "ENUM"i !IdentRest
ERROR_KW                         = "ERROR"i !IdentRest
ERRORS_KW                        = "ERRORS"i !IdentRest
ESCAPE_KW                        = "ESCAPE"i !IdentRest
ESCAPED_KW                       = "ESCAPED"i !IdentRest
EVENT_KW                         = "EVENT"i !IdentRest
EVENTS_KW                        = "EVENTS"i !IdentRest
EVERY_KW                         = "EVERY"i !IdentRest
EXCHANGE_KW                      = "EXCHANGE"i !IdentRest
EXECUTE_KW                       = "EXECUTE"i !IdentRest
EXISTS_KW                        = "EXISTS"i !IdentRest
EXIT_KW                          = "EXIT"i !IdentRest
EXPANSION_KW                     = "EXPANSION"i !IdentRest
EXPIRE_KW                        = "EXPIRE"i !IdentRest
EXPLAIN_KW                       = "EXPLAIN"i !IdentRest
EXPORT_KW                        = "EXPORT"i !IdentRest
EXTENDED_KW                      = "EXTENDED"i !IdentRest
EXTENT_SIZE_KW                   = "EXTENT_SIZE"i !IdentRest
FALSE_KW                         = "FALSE"i !IdentRest
FAST_KW                          = "FAST"i !IdentRest
FAULTS_KW                        = "FAULTS"i !IdentRest
FETCH_KW                         = "FETCH"i !IdentRest
FIELDS_KW                        = "FIELDS"i !IdentRest
FILE_KW                          = "FILE"i !IdentRest
FILE_BLOCK_SIZE_KW               = "FILE_BLOCK_SIZE[f]"i !IdentRest
FILTER_KW                        = "FILTER[g]"i !IdentRest
FIRST_KW                         = "FIRST"i !IdentRest
FIXED_KW                         = "FIXED"i !IdentRest
FLOAT_KW                         = "FLOAT"i !IdentRest
FLOAT4_KW                        = "FLOAT4"i !IdentRest
FLOAT8_KW                        = "FLOAT8"i !IdentRest
FLUSH_KW                         = "FLUSH"i !IdentRest
FOLLOWS_KW                       = "FOLLOWS[h]"i !IdentRest
FOR_KW                           = "FOR"i !IdentRest
FORCE_KW                         = "FORCE"i !IdentRest
FOREIGN_KW                       = "FOREIGN"i !IdentRest
FORMAT_KW                        = "FORMAT"i !IdentRest
FOUND_KW                         = "FOUND"i !IdentRest
FROM_KW                          = "FROM"i !IdentRest
FULL_KW                          = "FULL"i !IdentRest
FULLTEXT_KW                      = "FULLTEXT"i !IdentRest
FUNCTION_KW                      = "FUNCTION"i !IdentRest
GENERAL_KW                       = "GENERAL"i !IdentRest
GENERATED_KW                     = "GENERATED[i]"i !IdentRest
GEOMETRY_KW                      = "GEOMETRY"i !IdentRest
GEOMETRYCOLLECTION_KW            = "GEOMETRYCOLLECTION"i !IdentRest
GET_KW                           = "GET"i !IdentRest
GET_FORMAT_KW                    = "GET_FORMAT"i !IdentRest
GLOBAL_KW                        = "GLOBAL"i !IdentRest
GRANT_KW                         = "GRANT"i !IdentRest
GRANTS_KW                        = "GRANTS"i !IdentRest
GROUP_KW                         = "GROUP"i !IdentRest
GROUP_REPLICATION_KW             = "GROUP_REPLICATION[j]"i !IdentRest
HANDLER_KW                       = "HANDLER"i !IdentRest
HASH_KW                          = "HASH"i !IdentRest
HAVING_KW                        = "HAVING"i !IdentRest
HELP_KW                          = "HELP"i !IdentRest
HIGH_PRIORITY_KW                 = "HIGH_PRIORITY"i !IdentRest
HOST_KW                          = "HOST"i !IdentRest
HOSTS_KW                         = "HOSTS"i !IdentRest
HOUR_KW                          = "HOUR"i !IdentRest
HOUR_MICROSECOND_KW              = "HOUR_MICROSECOND"i !IdentRest
HOUR_MINUTE_KW                   = "HOUR_MINUTE"i !IdentRest
HOUR_SECOND_KW                   = "HOUR_SECOND"i !IdentRest
IDENTIFIED_KW                    = "IDENTIFIED"i !IdentRest
IF_KW                            = "IF"i !IdentRest
IGNORE_KW                        = "IGNORE"i !IdentRest
IGNORE_SERVER_IDS_KW             = "IGNORE_SERVER_IDS"i !IdentRest
IMPORT_KW                        = "IMPORT"i !IdentRest
IN_KW                            = "IN"i !IdentRest
INDEX_KW                         = "INDEX"i !IdentRest
INDEXES_KW                       = "INDEXES"i !IdentRest
INFILE_KW                        = "INFILE"i !IdentRest
INITIAL_SIZE_KW                  = "INITIAL_SIZE"i !IdentRest
INNER_KW                         = "INNER"i !IdentRest
INOUT_KW                         = "INOUT"i !IdentRest
INSENSITIVE_KW                   = "INSENSITIVE"i !IdentRest
INSERT_KW                        = "INSERT"i !IdentRest
INSERT_METHOD_KW                 = "INSERT_METHOD"i !IdentRest
INSTALL_KW                       = "INSTALL"i !IdentRest
INSTANCE_KW                      = "INSTANCE[k]"i !IdentRest
INT_KW                           = "INT"i !IdentRest
INT1_KW                          = "INT1"i !IdentRest
INT2_KW                          = "INT2"i !IdentRest
INT3_KW                          = "INT3"i !IdentRest
INT4_KW                          = "INT4"i !IdentRest
INT8_KW                          = "INT8"i !IdentRest
INTEGER_KW                       = "INTEGER"i !IdentRest
INTERVAL_KW                      = "INTERVAL"i !IdentRest
INTO_KW                          = "INTO"i !IdentRest
INVOKER_KW                       = "INVOKER"i !IdentRest
IO_KW                            = "IO"i !IdentRest
IO_AFTER_GTIDS_KW                = "IO_AFTER_GTIDS"i !IdentRest
IO_BEFORE_GTIDS_KW               = "IO_BEFORE_GTIDS"i !IdentRest
IO_THREAD_KW                     = "IO_THREAD"i !IdentRest
IPC_KW                           = "IPC"i !IdentRest
IS_KW                            = "IS"i !IdentRest
ISOLATION_KW                     = "ISOLATION"i !IdentRest
ISSUER_KW                        = "ISSUER"i !IdentRest
ITERATE_KW                       = "ITERATE"i !IdentRest
JOIN_KW                          = "JOIN"i !IdentRest
JSON_KW                          = "JSON[l]"i !IdentRest
KEY_KW                           = "KEY"i !IdentRest
KEYS_KW                          = "KEYS"i !IdentRest
KEY_BLOCK_SIZE_KW                = "KEY_BLOCK_SIZE"i !IdentRest
KILL_KW                          = "KILL"i !IdentRest
LANGUAGE_KW                      = "LANGUAGE"i !IdentRest
LAST_KW                          = "LAST"i !IdentRest
LEADING_KW                       = "LEADING"i !IdentRest
LEAVE_KW                         = "LEAVE"i !IdentRest
LEAVES_KW                        = "LEAVES"i !IdentRest
LEFT_KW                          = "LEFT"i !IdentRest
LESS_KW                          = "LESS"i !IdentRest
LEVEL_KW                         = "LEVEL"i !IdentRest
LIKE_KW                          = "LIKE"i !IdentRest
LIMIT_KW                         = "LIMIT"i !IdentRest
LINEAR_KW                        = "LINEAR"i !IdentRest
LINES_KW                         = "LINES"i !IdentRest
LINESTRING_KW                    = "LINESTRING"i !IdentRest
LIST_KW                          = "LIST"i !IdentRest
LOAD_KW                          = "LOAD"i !IdentRest
LOCAL_KW                         = "LOCAL"i !IdentRest
LOCALTIME_KW                     = "LOCALTIME"i !IdentRest
LOCALTIMESTAMP_KW                = "LOCALTIMESTAMP"i !IdentRest
LOCK_KW                          = "LOCK"i !IdentRest
LOCKS_KW                         = "LOCKS"i !IdentRest
LOGFILE_KW                       = "LOGFILE"i !IdentRest
LOGS_KW                          = "LOGS"i !IdentRest
LONG_KW                          = "LONG"i !IdentRest
LONGBLOB_KW                      = "LONGBLOB"i !IdentRest
LONGTEXT_KW                      = "LONGTEXT"i !IdentRest
LOOP_KW                          = "LOOP"i !IdentRest
LOW_PRIORITY_KW                  = "LOW_PRIORITY"i !IdentRest
MASTER_KW                        = "MASTER"i !IdentRest
MASTER_AUTO_POSITION_KW          = "MASTER_AUTO_POSITION"i !IdentRest
MASTER_BIND_KW                   = "MASTER_BIND"i !IdentRest
MASTER_CONNECT_RETRY_KW          = "MASTER_CONNECT_RETRY"i !IdentRest
MASTER_DELAY_KW                  = "MASTER_DELAY"i !IdentRest
MASTER_HEARTBEAT_PERIOD_KW       = "MASTER_HEARTBEAT_PERIOD"i !IdentRest
MASTER_HOST_KW                   = "MASTER_HOST"i !IdentRest
MASTER_LOG_FILE_KW               = "MASTER_LOG_FILE"i !IdentRest
MASTER_LOG_POS_KW                = "MASTER_LOG_POS"i !IdentRest
MASTER_PASSWORD_KW               = "MASTER_PASSWORD"i !IdentRest
MASTER_PORT_KW                   = "MASTER_PORT"i !IdentRest
MASTER_RETRY_COUNT_KW            = "MASTER_RETRY_COUNT"i !IdentRest
MASTER_SERVER_ID_KW              = "MASTER_SERVER_ID"i !IdentRest
MASTER_SSL_KW                    = "MASTER_SSL"i !IdentRest
MASTER_SSL_CA_KW                 = "MASTER_SSL_CA"i !IdentRest
MASTER_SSL_CAPATH_KW             = "MASTER_SSL_CAPATH"i !IdentRest
MASTER_SSL_CERT_KW               = "MASTER_SSL_CERT"i !IdentRest
MASTER_SSL_CIPHER_KW             = "MASTER_SSL_CIPHER"i !IdentRest
MASTER_SSL_CRL_KW                = "MASTER_SSL_CRL"i !IdentRest
MASTER_SSL_CRLPATH_KW            = "MASTER_SSL_CRLPATH"i !IdentRest
MASTER_SSL_KEY_KW                = "MASTER_SSL_KEY"i !IdentRest
MASTER_SSL_VERIFY_SERVER_CERT_KW = "MASTER_SSL_VERIFY_SERVER_CERT"i !IdentRest
MASTER_TLS_VERSION_KW            = "MASTER_TLS_VERSION[m]"i !IdentRest
MASTER_USER_KW                   = "MASTER_USER"i !IdentRest
MATCH_KW                         = "MATCH"i !IdentRest
MAXVALUE_KW                      = "MAXVALUE"i !IdentRest
MAX_CONNECTIONS_PER_HOUR_KW      = "MAX_CONNECTIONS_PER_HOUR"i !IdentRest
MAX_QUERIES_PER_HOUR_KW          = "MAX_QUERIES_PER_HOUR"i !IdentRest
MAX_ROWS_KW                      = "MAX_ROWS"i !IdentRest
MAX_SIZE_KW                      = "MAX_SIZE"i !IdentRest
MAX_STATEMENT_TIME_KW            = "MAX_STATEMENT_TIME[n]"i !IdentRest
MAX_UPDATES_PER_HOUR_KW          = "MAX_UPDATES_PER_HOUR"i !IdentRest
MAX_USER_CONNECTIONS_KW          = "MAX_USER_CONNECTIONS"i !IdentRest
MEDIUM_KW                        = "MEDIUM"i !IdentRest
MEDIUMBLOB_KW                    = "MEDIUMBLOB"i !IdentRest
MEDIUMINT_KW                     = "MEDIUMINT"i !IdentRest
MEDIUMTEXT_KW                    = "MEDIUMTEXT"i !IdentRest
MEMORY_KW                        = "MEMORY"i !IdentRest
MERGE_KW                         = "MERGE"i !IdentRest
MESSAGE_TEXT_KW                  = "MESSAGE_TEXT"i !IdentRest
MICROSECOND_KW                   = "MICROSECOND"i !IdentRest
MIDDLEINT_KW                     = "MIDDLEINT"i !IdentRest
MIGRATE_KW                       = "MIGRATE"i !IdentRest
MINUTE_KW                        = "MINUTE"i !IdentRest
MINUTE_MICROSECOND_KW            = "MINUTE_MICROSECOND"i !IdentRest
MINUTE_SECOND_KW                 = "MINUTE_SECOND"i !IdentRest
MIN_ROWS_KW                      = "MIN_ROWS"i !IdentRest
MOD_KW                           = "MOD"i !IdentRest
MODE_KW                          = "MODE"i !IdentRest
MODIFIES_KW                      = "MODIFIES"i !IdentRest
MODIFY_KW                        = "MODIFY"i !IdentRest
MONTH_KW                         = "MONTH"i !IdentRest
MULTILINESTRING_KW               = "MULTILINESTRING"i !IdentRest
MULTIPOINT_KW                    = "MULTIPOINT"i !IdentRest
MULTIPOLYGON_KW                  = "MULTIPOLYGON"i !IdentRest
MUTEX_KW                         = "MUTEX"i !IdentRest
MYSQL_ERRNO_KW                   = "MYSQL_ERRNO"i !IdentRest
NAME_KW                          = "NAME"i !IdentRest
NAMES_KW                         = "NAMES"i !IdentRest
NATIONAL_KW                      = "NATIONAL"i !IdentRest
NATURAL_KW                       = "NATURAL"i !IdentRest
NCHAR_KW                         = "NCHAR"i !IdentRest
NDB_KW                           = "NDB"i !IdentRest
NDBCLUSTER_KW                    = "NDBCLUSTER"i !IdentRest
NEVER_KW                         = "NEVER[o]"i !IdentRest
NEW_KW                           = "NEW"i !IdentRest
NEXT_KW                          = "NEXT"i !IdentRest
NO_KW                            = "NO"i !IdentRest
NODEGROUP_KW                     = "NODEGROUP"i !IdentRest
NONBLOCKING_KW                   = "NONBLOCKING[p]"i !IdentRest
NONE_KW                          = "NONE"i !IdentRest
NOT_KW                           = "NOT"i !IdentRest
NO_WAIT_KW                       = "NO_WAIT"i !IdentRest
NO_WRITE_TO_BINLOG_KW            = "NO_WRITE_TO_BINLOG"i !IdentRest
NULL_KW                          = "NULL"i !IdentRest
NUMBER_KW                        = "NUMBER"i !IdentRest
NUMERIC_KW                       = "NUMERIC"i !IdentRest
NVARCHAR_KW                      = "NVARCHAR"i !IdentRest
OFFSET_KW                        = "OFFSET"i !IdentRest
OLD_PASSWORD_KW                  = "OLD_PASSWORD[q]"i !IdentRest
ON_KW                            = "ON"i !IdentRest
ONE_KW                           = "ONE"i !IdentRest
ONLY_KW                          = "ONLY"i !IdentRest
OPEN_KW                          = "OPEN"i !IdentRest
OPTIMIZE_KW                      = "OPTIMIZE"i !IdentRest
OPTIMIZER_COSTS_KW               = "OPTIMIZER_COSTS[r]"i !IdentRest
OPTION_KW                        = "OPTION"i !IdentRest
OPTIONALLY_KW                    = "OPTIONALLY"i !IdentRest
OPTIONS_KW                       = "OPTIONS"i !IdentRest
OR_KW                            = "OR"i !IdentRest
ORDER_KW                         = "ORDER"i !IdentRest
OUT_KW                           = "OUT"i !IdentRest
OUTER_KW                         = "OUTER"i !IdentRest
OUTFILE_KW                       = "OUTFILE"i !IdentRest
OWNER_KW                         = "OWNER"i !IdentRest
PACK_KEYS_KW                     = "PACK_KEYS"i !IdentRest
PAGE_KW                          = "PAGE"i !IdentRest
PARSER_KW                        = "PARSER"i !IdentRest
PARSE_GCOL_EXPR_KW               = "PARSE_GCOL_EXPR[s]"i !IdentRest
PARTIAL_KW                       = "PARTIAL"i !IdentRest
PARTITION_KW                     = "PARTITION"i !IdentRest
PARTITIONING_KW                  = "PARTITIONING"i !IdentRest
PARTITIONS_KW                    = "PARTITIONS"i !IdentRest
PASSWORD_KW                      = "PASSWORD"i !IdentRest
PHASE_KW                         = "PHASE"i !IdentRest
PLUGIN_KW                        = "PLUGIN"i !IdentRest
PLUGINS_KW                       = "PLUGINS"i !IdentRest
PLUGIN_DIR_KW                    = "PLUGIN_DIR"i !IdentRest
POINT_KW                         = "POINT"i !IdentRest
POLYGON_KW                       = "POLYGON"i !IdentRest
PORT_KW                          = "PORT"i !IdentRest
PRECEDES_KW                      = "PRECEDES[t]"i !IdentRest
PRECISION_KW                     = "PRECISION"i !IdentRest
PREPARE_KW                       = "PREPARE"i !IdentRest
PRESERVE_KW                      = "PRESERVE"i !IdentRest
PREV_KW                          = "PREV"i !IdentRest
PRIMARY_KW                       = "PRIMARY"i !IdentRest
PRIVILEGES_KW                    = "PRIVILEGES"i !IdentRest
PROCEDURE_KW                     = "PROCEDURE"i !IdentRest
PROCESSLIST_KW                   = "PROCESSLIST"i !IdentRest
PROFILE_KW                       = "PROFILE"i !IdentRest
PROFILES_KW                      = "PROFILES"i !IdentRest
PROXY_KW                         = "PROXY"i !IdentRest
PURGE_KW                         = "PURGE"i !IdentRest
QUARTER_KW                       = "QUARTER"i !IdentRest
QUERY_KW                         = "QUERY"i !IdentRest
QUICK_KW                         = "QUICK"i !IdentRest
RANGE_KW                         = "RANGE"i !IdentRest
READ_KW                          = "READ"i !IdentRest
READS_KW                         = "READS"i !IdentRest
READ_ONLY_KW                     = "READ_ONLY"i !IdentRest
READ_WRITE_KW                    = "READ_WRITE"i !IdentRest
REAL_KW                          = "REAL"i !IdentRest
REBUILD_KW                       = "REBUILD"i !IdentRest
RECOVER_KW                       = "RECOVER"i !IdentRest
REDOFILE_KW                      = "REDOFILE"i !IdentRest
REDO_BUFFER_SIZE_KW              = "REDO_BUFFER_SIZE"i !IdentRest
REDUNDANT_KW                     = "REDUNDANT"i !IdentRest
REFERENCES_KW                    = "REFERENCES"i !IdentRest
REGEXP_KW                        = "REGEXP"i !IdentRest
RELAY_KW                         = "RELAY"i !IdentRest
RELAYLOG_KW                      = "RELAYLOG"i !IdentRest
RELAY_LOG_FILE_KW                = "RELAY_LOG_FILE"i !IdentRest
RELAY_LOG_POS_KW                 = "RELAY_LOG_POS"i !IdentRest
RELAY_THREAD_KW                  = "RELAY_THREAD"i !IdentRest
RELEASE_KW                       = "RELEASE"i !IdentRest
RELOAD_KW                        = "RELOAD"i !IdentRest
REMOVE_KW                        = "REMOVE"i !IdentRest
RENAME_KW                        = "RENAME"i !IdentRest
REORGANIZE_KW                    = "REORGANIZE"i !IdentRest
REPAIR_KW                        = "REPAIR"i !IdentRest
REPEAT_KW                        = "REPEAT"i !IdentRest
REPEATABLE_KW                    = "REPEATABLE"i !IdentRest
REPLACE_KW                       = "REPLACE"i !IdentRest
REPLICATE_DO_DB_KW               = "REPLICATE_DO_DB[u]"i !IdentRest
REPLICATE_DO_TABLE_KW            = "REPLICATE_DO_TABLE[v]"i !IdentRest
REPLICATE_IGNORE_DB_KW           = "REPLICATE_IGNORE_DB[w]"i !IdentRest
REPLICATE_IGNORE_TABLE_KW        = "REPLICATE_IGNORE_TABLE[x]"i !IdentRest
REPLICATE_REWRITE_DB_KW          = "REPLICATE_REWRITE_DB[y]"i !IdentRest
REPLICATE_WILD_DO_TABLE_KW       = "REPLICATE_WILD_DO_TABLE[z]"i !IdentRest
REPLICATE_WILD_IGNORE_TABLE_KW   = "REPLICATE_WILD_IGNORE_TABLE[aa]"i !IdentRest
REPLICATION_KW                   = "REPLICATION"i !IdentRest
REQUIRE_KW                       = "REQUIRE"i !IdentRest
RESET_KW                         = "RESET"i !IdentRest
RESIGNAL_KW                      = "RESIGNAL"i !IdentRest
RESTORE_KW                       = "RESTORE"i !IdentRest
RESTRICT_KW                      = "RESTRICT"i !IdentRest
RESUME_KW                        = "RESUME"i !IdentRest
RETURN_KW                        = "RETURN"i !IdentRest
RETURNED_SQLSTATE_KW             = "RETURNED_SQLSTATE"i !IdentRest
RETURNS_KW                       = "RETURNS"i !IdentRest
REVERSE_KW                       = "REVERSE"i !IdentRest
REVOKE_KW                        = "REVOKE"i !IdentRest
RIGHT_KW                         = "RIGHT"i !IdentRest
RLIKE_KW                         = "RLIKE"i !IdentRest
ROLLBACK_KW                      = "ROLLBACK"i !IdentRest
ROLLUP_KW                        = "ROLLUP"i !IdentRest
ROTATE_KW                        = "ROTATE[ab]"i !IdentRest
ROUTINE_KW                       = "ROUTINE"i !IdentRest
ROW_KW                           = "ROW"i !IdentRest
ROWS_KW                          = "ROWS"i !IdentRest
ROW_COUNT_KW                     = "ROW_COUNT"i !IdentRest
ROW_FORMAT_KW                    = "ROW_FORMAT"i !IdentRest
RTREE_KW                         = "RTREE"i !IdentRest
SAVEPOINT_KW                     = "SAVEPOINT"i !IdentRest
SCHEDULE_KW                      = "SCHEDULE"i !IdentRest
SCHEMA_KW                        = "SCHEMA"i !IdentRest
SCHEMAS_KW                       = "SCHEMAS"i !IdentRest
SCHEMA_NAME_KW                   = "SCHEMA_NAME"i !IdentRest
SECOND_KW                        = "SECOND"i !IdentRest
SECOND_MICROSECOND_KW            = "SECOND_MICROSECOND"i !IdentRest
SECURITY_KW                      = "SECURITY"i !IdentRest
SELECT_KW                        = "SELECT"i !IdentRest
SENSITIVE_KW                     = "SENSITIVE"i !IdentRest
SEPARATOR_KW                     = "SEPARATOR"i !IdentRest
SERIAL_KW                        = "SERIAL"i !IdentRest
SERIALIZABLE_KW                  = "SERIALIZABLE"i !IdentRest
SERVER_KW                        = "SERVER"i !IdentRest
SESSION_KW                       = "SESSION"i !IdentRest
SET_KW                           = "SET"i !IdentRest
SHARE_KW                         = "SHARE"i !IdentRest
SHOW_KW                          = "SHOW"i !IdentRest
SHUTDOWN_KW                      = "SHUTDOWN"i !IdentRest
SIGNAL_KW                        = "SIGNAL"i !IdentRest
SIGNED_KW                        = "SIGNED"i !IdentRest
SIMPLE_KW                        = "SIMPLE"i !IdentRest
SLAVE_KW                         = "SLAVE"i !IdentRest
SLOW_KW                          = "SLOW"i !IdentRest
SMALLINT_KW                      = "SMALLINT"i !IdentRest
SNAPSHOT_KW                      = "SNAPSHOT"i !IdentRest
SOCKET_KW                        = "SOCKET"i !IdentRest
SOME_KW                          = "SOME"i !IdentRest
SONAME_KW                        = "SONAME"i !IdentRest
SOUNDS_KW                        = "SOUNDS"i !IdentRest
SOURCE_KW                        = "SOURCE"i !IdentRest
SPATIAL_KW                       = "SPATIAL"i !IdentRest
SPECIFIC_KW                      = "SPECIFIC"i !IdentRest
SQL_KW                           = "SQL"i !IdentRest
SQLEXCEPTION_KW                  = "SQLEXCEPTION"i !IdentRest
SQLSTATE_KW                      = "SQLSTATE"i !IdentRest
SQLWARNING_KW                    = "SQLWARNING"i !IdentRest
SQL_AFTER_GTIDS_KW               = "SQL_AFTER_GTIDS"i !IdentRest
SQL_AFTER_MTS_GAPS_KW            = "SQL_AFTER_MTS_GAPS"i !IdentRest
SQL_BEFORE_GTIDS_KW              = "SQL_BEFORE_GTIDS"i !IdentRest
SQL_BIG_RESULT_KW                = "SQL_BIG_RESULT"i !IdentRest
SQL_BUFFER_RESULT_KW             = "SQL_BUFFER_RESULT"i !IdentRest
SQL_CACHE_KW                     = "SQL_CACHE"i !IdentRest
SQL_CALC_FOUND_ROWS_KW           = "SQL_CALC_FOUND_ROWS"i !IdentRest
SQL_NO_CACHE_KW                  = "SQL_NO_CACHE"i !IdentRest
SQL_SMALL_RESULT_KW              = "SQL_SMALL_RESULT"i !IdentRest
SQL_THREAD_KW                    = "SQL_THREAD"i !IdentRest
SQL_TSI_DAY_KW                   = "SQL_TSI_DAY"i !IdentRest
SQL_TSI_HOUR_KW                  = "SQL_TSI_HOUR"i !IdentRest
SQL_TSI_MINUTE_KW                = "SQL_TSI_MINUTE"i !IdentRest
SQL_TSI_MONTH_KW                 = "SQL_TSI_MONTH"i !IdentRest
SQL_TSI_QUARTER_KW               = "SQL_TSI_QUARTER"i !IdentRest
SQL_TSI_SECOND_KW                = "SQL_TSI_SECOND"i !IdentRest
SQL_TSI_WEEK_KW                  = "SQL_TSI_WEEK"i !IdentRest
SQL_TSI_YEAR_KW                  = "SQL_TSI_YEAR"i !IdentRest
SSL_KW                           = "SSL"i !IdentRest
STACKED_KW                       = "STACKED"i !IdentRest
START_KW                         = "START"i !IdentRest
STARTING_KW                      = "STARTING"i !IdentRest
STARTS_KW                        = "STARTS"i !IdentRest
STATS_AUTO_RECALC_KW             = "STATS_AUTO_RECALC"i !IdentRest
STATS_PERSISTENT_KW              = "STATS_PERSISTENT"i !IdentRest
STATS_SAMPLE_PAGES_KW            = "STATS_SAMPLE_PAGES"i !IdentRest
STATUS_KW                        = "STATUS"i !IdentRest
STOP_KW                          = "STOP"i !IdentRest
STORAGE_KW                       = "STORAGE"i !IdentRest
STORED_KW                        = "STORED[ac]"i !IdentRest
STRAIGHT_JOIN_KW                 = "STRAIGHT_JOIN"i !IdentRest
STRING_KW                        = "STRING"i !IdentRest
SUBCLASS_ORIGIN_KW               = "SUBCLASS_ORIGIN"i !IdentRest
SUBJECT_KW                       = "SUBJECT"i !IdentRest
SUBPARTITION_KW                  = "SUBPARTITION"i !IdentRest
SUBPARTITIONS_KW                 = "SUBPARTITIONS"i !IdentRest
SUPER_KW                         = "SUPER"i !IdentRest
SUSPEND_KW                       = "SUSPEND"i !IdentRest
SWAPS_KW                         = "SWAPS"i !IdentRest
SWITCHES_KW                      = "SWITCHES"i !IdentRest
TABLE_KW                         = "TABLE"i !IdentRest
TABLES_KW                        = "TABLES"i !IdentRest
TABLESPACE_KW                    = "TABLESPACE"i !IdentRest
TABLE_CHECKSUM_KW                = "TABLE_CHECKSUM"i !IdentRest
TABLE_NAME_KW                    = "TABLE_NAME"i !IdentRest
TEMPORARY_KW                     = "TEMPORARY"i !IdentRest
TEMPTABLE_KW                     = "TEMPTABLE"i !IdentRest
TERMINATED_KW                    = "TERMINATED"i !IdentRest
TEXT_KW                          = "TEXT"i !IdentRest
THAN_KW                          = "THAN"i !IdentRest
THEN_KW                          = "THEN"i !IdentRest
TIME_KW                          = "TIME"i !IdentRest
TIMESTAMP_KW                     = "TIMESTAMP"i !IdentRest
TIMESTAMPADD_KW                  = "TIMESTAMPADD"i !IdentRest
TIMESTAMPDIFF_KW                 = "TIMESTAMPDIFF"i !IdentRest
TINYBLOB_KW                      = "TINYBLOB"i !IdentRest
TINYINT_KW                       = "TINYINT"i !IdentRest
TINYTEXT_KW                      = "TINYTEXT"i !IdentRest
TO_KW                            = "TO"i !IdentRest
TRAILING_KW                      = "TRAILING"i !IdentRest
TRANSACTION_KW                   = "TRANSACTION"i !IdentRest
TRIGGER_KW                       = "TRIGGER"i !IdentRest
TRIGGERS_KW                      = "TRIGGERS"i !IdentRest
TRUE_KW                          = "TRUE"i !IdentRest
TRUNCATE_KW                      = "TRUNCATE"i !IdentRest
TYPE_KW                          = "TYPE"i !IdentRest
TYPES_KW                         = "TYPES"i !IdentRest
UNCOMMITTED_KW                   = "UNCOMMITTED"i !IdentRest
UNDEFINED_KW                     = "UNDEFINED"i !IdentRest
UNDO_KW                          = "UNDO"i !IdentRest
UNDOFILE_KW                      = "UNDOFILE"i !IdentRest
UNDO_BUFFER_SIZE_KW              = "UNDO_BUFFER_SIZE"i !IdentRest
UNICODE_KW                       = "UNICODE"i !IdentRest
UNINSTALL_KW                     = "UNINSTALL"i !IdentRest
UNION_KW                         = "UNION"i !IdentRest
UNIQUE_KW                        = "UNIQUE"i !IdentRest
UNKNOWN_KW                       = "UNKNOWN"i !IdentRest
UNLOCK_KW                        = "UNLOCK"i !IdentRest
UNSIGNED_KW                      = "UNSIGNED"i !IdentRest
UNTIL_KW                         = "UNTIL"i !IdentRest
UPDATE_KW                        = "UPDATE"i !IdentRest
UPGRADE_KW                       = "UPGRADE"i !IdentRest
USAGE_KW                         = "USAGE"i !IdentRest
USE_KW                           = "USE"i !IdentRest
USER_KW                          = "USER"i !IdentRest
USER_RESOURCES_KW                = "USER_RESOURCES"i !IdentRest
USE_FRM_KW                       = "USE_FRM"i !IdentRest
USING_KW                         = "USING"i !IdentRest
UTC_DATE_KW                      = "UTC_DATE"i !IdentRest
UTC_TIME_KW                      = "UTC_TIME"i !IdentRest
UTC_TIMESTAMP_KW                 = "UTC_TIMESTAMP"i !IdentRest
VALIDATION_KW                    = "VALIDATION[ad]"i !IdentRest
VALUE_KW                         = "VALUE"i !IdentRest
VALUES_KW                        = "VALUES"i !IdentRest
VARBINARY_KW                     = "VARBINARY"i !IdentRest
VARCHAR_KW                       = "VARCHAR"i !IdentRest
VARCHARACTER_KW                  = "VARCHARACTER"i !IdentRest
VARIABLES_KW                     = "VARIABLES"i !IdentRest
VARYING_KW                       = "VARYING"i !IdentRest
VIEW_KW                          = "VIEW"i !IdentRest
VIRTUAL_KW                       = "VIRTUAL"i !IdentRest
WAIT_KW                          = "WAIT"i !IdentRest
WARNINGS_KW                      = "WARNINGS"i !IdentRest
WEEK_KW                          = "WEEK"i !IdentRest
WEIGHT_STRING_KW                 = "WEIGHT_STRING"i !IdentRest
WHEN_KW                          = "WHEN"i !IdentRest
WHERE_KW                         = "WHERE"i !IdentRest
WHILE_KW                         = "WHILE"i !IdentRest
WITH_KW                          = "WITH"i !IdentRest
WITHOUT_KW                       = "WITHOUT"i !IdentRest
WORK_KW                          = "WORK"i !IdentRest
WRAPPER_KW                       = "WRAPPER"i !IdentRest
WRITE_KW                         = "WRITE"i !IdentRest
X509_KW                          = "X509"i !IdentRest
XA_KW                            = "XA"i !IdentRest
XID_KW                           = "XID"i !IdentRest
XML_KW                           = "XML"i !IdentRest
XOR_KW                           = "XOR"i !IdentRest
YEAR_KW                          = "YEAR"i !IdentRest
YEAR_MONTH_KW                    = "YEAR_MONTH"i !IdentRest
ZEROFILL_KW                      = "ZEROFILL"i !IdentRest

/* Reserved Words */
ReservedWord
  = ACCESSIBLE_KW
  / ACCOUNT_KW
  / ACTION_KW
  / ADD_KW
  / AFTER_KW
  / AGAINST_KW
  / AGGREGATE_KW
  / ALGORITHM_KW
  / ALL_KW
  / ALTER_KW
  / ALWAYS_KW
  / ANALYSE_KW
  / ANALYZE_KW
  / AND_KW
  / ANY_KW
  / AS_KW
  / ASC_KW
  / ASCII_KW
  / ASENSITIVE_KW
  / AT_KW
  / AUTOEXTEND_SIZE_KW
  / AUTO_INCREMENT_KW
  / AVG_KW
  / AVG_ROW_LENGTH_KW
  / BACKUP_KW
  / BEFORE_KW
  / BEGIN_KW
  / BETWEEN_KW
  / BIGINT_KW
  / BINARY_KW
  / BINLOG_KW
  / BIT_KW
  / BLOB_KW
  / BLOCK_KW
  / BOOL_KW
  / BOOLEAN_KW
  / BOTH_KW
  / BTREE_KW
  / BY_KW
  / BYTE_KW
  / CACHE_KW
  / CALL_KW
  / CASCADE_KW
  / CASCADED_KW
  / CASE_KW
  / CATALOG_NAME_KW
  / CHAIN_KW
  / CHANGE_KW
  / CHANGED_KW
  / CHANNEL_KW
  / CHAR_KW
  / CHARACTER_KW
  / CHARSET_KW
  / CHECK_KW
  / CHECKSUM_KW
  / CIPHER_KW
  / CLASS_ORIGIN_KW
  / CLIENT_KW
  / CLOSE_KW
  / COALESCE_KW
  / CODE_KW
  / COLLATE_KW
  / COLLATION_KW
  / COLUMN_KW
  / COLUMNS_KW
  / COLUMN_FORMAT_KW
  / COLUMN_NAME_KW
  / COMMENT_KW
  / COMMIT_KW
  / COMMITTED_KW
  / COMPACT_KW
  / COMPLETION_KW
  / COMPRESSED_KW
  / COMPRESSION_KW
  / CONCURRENT_KW
  / CONDITION_KW
  / CONNECTION_KW
  / CONSISTENT_KW
  / CONSTRAINT_KW
  / CONSTRAINT_CATALOG_KW
  / CONSTRAINT_NAME_KW
  / CONSTRAINT_SCHEMA_KW
  / CONTAINS_KW
  / CONTEXT_KW
  / CONTINUE_KW
  / CONVERT_KW
  / CPU_KW
  / CREATE_KW
  / CROSS_KW
  / CUBE_KW
  / CURRENT_KW
  / CURRENT_DATE_KW
  / CURRENT_TIME_KW
  / CURRENT_TIMESTAMP_KW
  / CURRENT_USER_KW
  / CURSOR_KW
  / CURSOR_NAME_KW
  / DATA_KW
  / DATABASE_KW
  / DATABASES_KW
  / DATAFILE_KW
  / DATE_KW
  / DATETIME_KW
  / DAY_KW
  / DAY_HOUR_KW
  / DAY_MICROSECOND_KW
  / DAY_MINUTE_KW
  / DAY_SECOND_KW
  / DEALLOCATE_KW
  / DEC_KW
  / DECIMAL_KW
  / DECLARE_KW
  / DEFAULT_KW
  / DEFAULT_AUTH_KW
  / DEFINER_KW
  / DELAYED_KW
  / DELAY_KEY_WRITE_KW
  / DELETE_KW
  / DESC_KW
  / DESCRIBE_KW
  / DES_KEY_FILE_KW
  / DETERMINISTIC_KW
  / DIAGNOSTICS_KW
  / DIRECTORY_KW
  / DISABLE_KW
  / DISCARD_KW
  / DISK_KW
  / DISTINCT_KW
  / DISTINCTROW_KW
  / DIV_KW
  / DO_KW
  / DOUBLE_KW
  / DROP_KW
  / DUAL_KW
  / DUMPFILE_KW
  / DUPLICATE_KW
  / DYNAMIC_KW
  / EACH_KW
  / ELSE_KW
  / ELSEIF_KW
  / ENABLE_KW
  / ENCLOSED_KW
  / ENCRYPTION_KW
  / END_KW
  / ENDS_KW
  / ENGINE_KW
  / ENGINES_KW
  / ENUM_KW
  / ERROR_KW
  / ERRORS_KW
  / ESCAPE_KW
  / ESCAPED_KW
  / EVENT_KW
  / EVENTS_KW
  / EVERY_KW
  / EXCHANGE_KW
  / EXECUTE_KW
  / EXISTS_KW
  / EXIT_KW
  / EXPANSION_KW
  / EXPIRE_KW
  / EXPLAIN_KW
  / EXPORT_KW
  / EXTENDED_KW
  / EXTENT_SIZE_KW
  / FALSE_KW
  / FAST_KW
  / FAULTS_KW
  / FETCH_KW
  / FIELDS_KW
  / FILE_KW
  / FILE_BLOCK_SIZE_KW
  / FILTER_KW
  / FIRST_KW
  / FIXED_KW
  / FLOAT_KW
  / FLOAT4_KW
  / FLOAT8_KW
  / FLUSH_KW
  / FOLLOWS_KW
  / FOR_KW
  / FORCE_KW
  / FOREIGN_KW
  / FORMAT_KW
  / FOUND_KW
  / FROM_KW
  / FULL_KW
  / FULLTEXT_KW
  / FUNCTION_KW
  / GENERAL_KW
  / GENERATED_KW
  / GEOMETRY_KW
  / GEOMETRYCOLLECTION_KW
  / GET_KW
  / GET_FORMAT_KW
  / GLOBAL_KW
  / GRANT_KW
  / GRANTS_KW
  / GROUP_KW
  / GROUP_REPLICATION_KW
  / HANDLER_KW
  / HASH_KW
  / HAVING_KW
  / HELP_KW
  / HIGH_PRIORITY_KW
  / HOST_KW
  / HOSTS_KW
  / HOUR_KW
  / HOUR_MICROSECOND_KW
  / HOUR_MINUTE_KW
  / HOUR_SECOND_KW
  / IDENTIFIED_KW
  / IF_KW
  / IGNORE_KW
  / IGNORE_SERVER_IDS_KW
  / IMPORT_KW
  / IN_KW
  / INDEX_KW
  / INDEXES_KW
  / INFILE_KW
  / INITIAL_SIZE_KW
  / INNER_KW
  / INOUT_KW
  / INSENSITIVE_KW
  / INSERT_KW
  / INSERT_METHOD_KW
  / INSTALL_KW
  / INSTANCE_KW
  / INT_KW
  / INT1_KW
  / INT2_KW
  / INT3_KW
  / INT4_KW
  / INT8_KW
  / INTEGER_KW
  / INTERVAL_KW
  / INTO_KW
  / INVOKER_KW
  / IO_KW
  / IO_AFTER_GTIDS_KW
  / IO_BEFORE_GTIDS_KW
  / IO_THREAD_KW
  / IPC_KW
  / IS_KW
  / ISOLATION_KW
  / ISSUER_KW
  / ITERATE_KW
  / JOIN_KW
  / JSON_KW
  / KEY_KW
  / KEYS_KW
  / KEY_BLOCK_SIZE_KW
  / KILL_KW
  / LANGUAGE_KW
  / LAST_KW
  / LEADING_KW
  / LEAVE_KW
  / LEAVES_KW
  / LEFT_KW
  / LESS_KW
  / LEVEL_KW
  / LIKE_KW
  / LIMIT_KW
  / LINEAR_KW
  / LINES_KW
  / LINESTRING_KW
  / LIST_KW
  / LOAD_KW
  / LOCAL_KW
  / LOCALTIME_KW
  / LOCALTIMESTAMP_KW
  / LOCK_KW
  / LOCKS_KW
  / LOGFILE_KW
  / LOGS_KW
  / LONG_KW
  / LONGBLOB_KW
  / LONGTEXT_KW
  / LOOP_KW
  / LOW_PRIORITY_KW
  / MASTER_KW
  / MASTER_AUTO_POSITION_KW
  / MASTER_BIND_KW
  / MASTER_CONNECT_RETRY_KW
  / MASTER_DELAY_KW
  / MASTER_HEARTBEAT_PERIOD_KW
  / MASTER_HOST_KW
  / MASTER_LOG_FILE_KW
  / MASTER_LOG_POS_KW
  / MASTER_PASSWORD_KW
  / MASTER_PORT_KW
  / MASTER_RETRY_COUNT_KW
  / MASTER_SERVER_ID_KW
  / MASTER_SSL_KW
  / MASTER_SSL_CA_KW
  / MASTER_SSL_CAPATH_KW
  / MASTER_SSL_CERT_KW
  / MASTER_SSL_CIPHER_KW
  / MASTER_SSL_CRL_KW
  / MASTER_SSL_CRLPATH_KW
  / MASTER_SSL_KEY_KW
  / MASTER_SSL_VERIFY_SERVER_CERT_KW
  / MASTER_TLS_VERSION_KW
  / MASTER_USER_KW
  / MATCH_KW
  / MAXVALUE_KW
  / MAX_CONNECTIONS_PER_HOUR_KW
  / MAX_QUERIES_PER_HOUR_KW
  / MAX_ROWS_KW
  / MAX_SIZE_KW
  / MAX_STATEMENT_TIME_KW
  / MAX_UPDATES_PER_HOUR_KW
  / MAX_USER_CONNECTIONS_KW
  / MEDIUM_KW
  / MEDIUMBLOB_KW
  / MEDIUMINT_KW
  / MEDIUMTEXT_KW
  / MEMORY_KW
  / MERGE_KW
  / MESSAGE_TEXT_KW
  / MICROSECOND_KW
  / MIDDLEINT_KW
  / MIGRATE_KW
  / MINUTE_KW
  / MINUTE_MICROSECOND_KW
  / MINUTE_SECOND_KW
  / MIN_ROWS_KW
  / MOD_KW
  / MODE_KW
  / MODIFIES_KW
  / MODIFY_KW
  / MONTH_KW
  / MULTILINESTRING_KW
  / MULTIPOINT_KW
  / MULTIPOLYGON_KW
  / MUTEX_KW
  / MYSQL_ERRNO_KW
  / NAME_KW
  / NAMES_KW
  / NATIONAL_KW
  / NATURAL_KW
  / NCHAR_KW
  / NDB_KW
  / NDBCLUSTER_KW
  / NEVER_KW
  / NEW_KW
  / NEXT_KW
  / NO_KW
  / NODEGROUP_KW
  / NONBLOCKING_KW
  / NONE_KW
  / NOT_KW
  / NO_WAIT_KW
  / NO_WRITE_TO_BINLOG_KW
  / NULL_KW
  / NUMBER_KW
  / NUMERIC_KW
  / NVARCHAR_KW
  / OFFSET_KW
  / OLD_PASSWORD_KW
  / ON_KW
  / ONE_KW
  / ONLY_KW
  / OPEN_KW
  / OPTIMIZE_KW
  / OPTIMIZER_COSTS_KW
  / OPTION_KW
  / OPTIONALLY_KW
  / OPTIONS_KW
  / OR_KW
  / ORDER_KW
  / OUT_KW
  / OUTER_KW
  / OUTFILE_KW
  / OWNER_KW
  / PACK_KEYS_KW
  / PAGE_KW
  / PARSER_KW
  / PARSE_GCOL_EXPR_KW
  / PARTIAL_KW
  / PARTITION_KW
  / PARTITIONING_KW
  / PARTITIONS_KW
  / PASSWORD_KW
  / PHASE_KW
  / PLUGIN_KW
  / PLUGINS_KW
  / PLUGIN_DIR_KW
  / POINT_KW
  / POLYGON_KW
  / PORT_KW
  / PRECEDES_KW
  / PRECISION_KW
  / PREPARE_KW
  / PRESERVE_KW
  / PREV_KW
  / PRIMARY_KW
  / PRIVILEGES_KW
  / PROCEDURE_KW
  / PROCESSLIST_KW
  / PROFILE_KW
  / PROFILES_KW
  / PROXY_KW
  / PURGE_KW
  / QUARTER_KW
  / QUERY_KW
  / QUICK_KW
  / RANGE_KW
  / READ_KW
  / READS_KW
  / READ_ONLY_KW
  / READ_WRITE_KW
  / REAL_KW
  / REBUILD_KW
  / RECOVER_KW
  / REDOFILE_KW
  / REDO_BUFFER_SIZE_KW
  / REDUNDANT_KW
  / REFERENCES_KW
  / REGEXP_KW
  / RELAY_KW
  / RELAYLOG_KW
  / RELAY_LOG_FILE_KW
  / RELAY_LOG_POS_KW
  / RELAY_THREAD_KW
  / RELEASE_KW
  / RELOAD_KW
  / REMOVE_KW
  / RENAME_KW
  / REORGANIZE_KW
  / REPAIR_KW
  / REPEAT_KW
  / REPEATABLE_KW
  / REPLACE_KW
  / REPLICATE_DO_DB_KW
  / REPLICATE_DO_TABLE_KW
  / REPLICATE_IGNORE_DB_KW
  / REPLICATE_IGNORE_TABLE_KW
  / REPLICATE_REWRITE_DB_KW
  / REPLICATE_WILD_DO_TABLE_KW
  / REPLICATE_WILD_IGNORE_TABLE_KW
  / REPLICATION_KW
  / REQUIRE_KW
  / RESET_KW
  / RESIGNAL_KW
  / RESTORE_KW
  / RESTRICT_KW
  / RESUME_KW
  / RETURN_KW
  / RETURNED_SQLSTATE_KW
  / RETURNS_KW
  / REVERSE_KW
  / REVOKE_KW
  / RIGHT_KW
  / RLIKE_KW
  / ROLLBACK_KW
  / ROLLUP_KW
  / ROTATE_KW
  / ROUTINE_KW
  / ROW_KW
  / ROWS_KW
  / ROW_COUNT_KW
  / ROW_FORMAT_KW
  / RTREE_KW
  / SAVEPOINT_KW
  / SCHEDULE_KW
  / SCHEMA_KW
  / SCHEMAS_KW
  / SCHEMA_NAME_KW
  / SECOND_KW
  / SECOND_MICROSECOND_KW
  / SECURITY_KW
  / SELECT_KW
  / SENSITIVE_KW
  / SEPARATOR_KW
  / SERIAL_KW
  / SERIALIZABLE_KW
  / SERVER_KW
  / SESSION_KW
  / SET_KW
  / SHARE_KW
  / SHOW_KW
  / SHUTDOWN_KW
  / SIGNAL_KW
  / SIGNED_KW
  / SIMPLE_KW
  / SLAVE_KW
  / SLOW_KW
  / SMALLINT_KW
  / SNAPSHOT_KW
  / SOCKET_KW
  / SOME_KW
  / SONAME_KW
  / SOUNDS_KW
  / SOURCE_KW
  / SPATIAL_KW
  / SPECIFIC_KW
  / SQL_KW
  / SQLEXCEPTION_KW
  / SQLSTATE_KW
  / SQLWARNING_KW
  / SQL_AFTER_GTIDS_KW
  / SQL_AFTER_MTS_GAPS_KW
  / SQL_BEFORE_GTIDS_KW
  / SQL_BIG_RESULT_KW
  / SQL_BUFFER_RESULT_KW
  / SQL_CACHE_KW
  / SQL_CALC_FOUND_ROWS_KW
  / SQL_NO_CACHE_KW
  / SQL_SMALL_RESULT_KW
  / SQL_THREAD_KW
  / SQL_TSI_DAY_KW
  / SQL_TSI_HOUR_KW
  / SQL_TSI_MINUTE_KW
  / SQL_TSI_MONTH_KW
  / SQL_TSI_QUARTER_KW
  / SQL_TSI_SECOND_KW
  / SQL_TSI_WEEK_KW
  / SQL_TSI_YEAR_KW
  / SSL_KW
  / STACKED_KW
  / START_KW
  / STARTING_KW
  / STARTS_KW
  / STATS_AUTO_RECALC_KW
  / STATS_PERSISTENT_KW
  / STATS_SAMPLE_PAGES_KW
  / STATUS_KW
  / STOP_KW
  / STORAGE_KW
  / STORED_KW
  / STRAIGHT_JOIN_KW
  / STRING_KW
  / SUBCLASS_ORIGIN_KW
  / SUBJECT_KW
  / SUBPARTITION_KW
  / SUBPARTITIONS_KW
  / SUPER_KW
  / SUSPEND_KW
  / SWAPS_KW
  / SWITCHES_KW
  / TABLE_KW
  / TABLES_KW
  / TABLESPACE_KW
  / TABLE_CHECKSUM_KW
  / TABLE_NAME_KW
  / TEMPORARY_KW
  / TEMPTABLE_KW
  / TERMINATED_KW
  / TEXT_KW
  / THAN_KW
  / THEN_KW
  / TIME_KW
  / TIMESTAMP_KW
  / TIMESTAMPADD_KW
  / TIMESTAMPDIFF_KW
  / TINYBLOB_KW
  / TINYINT_KW
  / TINYTEXT_KW
  / TO_KW
  / TRAILING_KW
  / TRANSACTION_KW
  / TRIGGER_KW
  / TRIGGERS_KW
  / TRUE_KW
  / TRUNCATE_KW
  / TYPE_KW
  / TYPES_KW
  / UNCOMMITTED_KW
  / UNDEFINED_KW
  / UNDO_KW
  / UNDOFILE_KW
  / UNDO_BUFFER_SIZE_KW
  / UNICODE_KW
  / UNINSTALL_KW
  / UNION_KW
  / UNIQUE_KW
  / UNKNOWN_KW
  / UNLOCK_KW
  / UNSIGNED_KW
  / UNTIL_KW
  / UPDATE_KW
  / UPGRADE_KW
  / USAGE_KW
  / USE_KW
  / USER_KW
  / USER_RESOURCES_KW
  / USE_FRM_KW
  / USING_KW
  / UTC_DATE_KW
  / UTC_TIME_KW
  / UTC_TIMESTAMP_KW
  / VALIDATION_KW
  / VALUE_KW
  / VALUES_KW
  / VARBINARY_KW
  / VARCHAR_KW
  / VARCHARACTER_KW
  / VARIABLES_KW
  / VARYING_KW
  / VIEW_KW
  / VIRTUAL_KW
  / WAIT_KW
  / WARNINGS_KW
  / WEEK_KW
  / WEIGHT_STRING_KW
  / WHEN_KW
  / WHERE_KW
  / WHILE_KW
  / WITH_KW
  / WITHOUT_KW
  / WORK_KW
  / WRAPPER_KW
  / WRITE_KW
  / X509_KW
  / XA_KW
  / XID_KW
  / XML_KW
  / XOR_KW
  / YEAR_KW
  / YEAR_MONTH_KW
  / ZEROFILL_KW
