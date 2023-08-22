const
  CHARSET_LENGTH_NAME = 24;
  CHARSET_LENGTH_ALIAS = 16;
  CHARSET_MAX_ALIASES = 10;
  CHARSET_RECORDS = 242;


type
charencoderecord = record
  setname:string[CHARSET_LENGTH_NAME];
  encoding: smallint;
end;

const
charencoding: array[1..CHARSET_RECORDS] of charencoderecord= (
(
  setname:'ADOBE-STANDARD-ENCODING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ADOBE-SYMBOL-ENCODING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'AMIGA-1251';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ANSI_X3.110-1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ASMO_449';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'BIG5';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'BIG5-HKSCS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'BOCU-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'BS_4730';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'BS_VIEWDATA';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'CESU-8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'CSA_Z243.4-1985-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'CSA_Z243.4-1985-2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'CSA_Z243.4-1985-GR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'CSN_369103';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'DEC-MCS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'DIN_66003';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'DS_2089';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-AT-DE';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-AT-DE-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-CA-FR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-DK-NO';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-DK-NO-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-ES';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-ES-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-ES-S';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-FI-SE';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-FI-SE-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-FR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-IT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-PT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-UK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EBCDIC-US';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ECMA-CYRILLIC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ES';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ES2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EUC-JP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EUC-KR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'EXTENDED_UNIX_CODE_FIXE';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GB18030';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GB2312';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GBK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GB_1988-80';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GB_2312-80';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GOST_19768-74';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GREEK-CCITT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GREEK7';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'GREEK7-OLD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'HP-DESKTOP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'HP-LEGAL';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'HP-MATH8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'HP-PI-FONT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'HP-ROMAN8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'HZ-GB-2312';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM-SYMBOLS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM-THAI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM00858';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM00924';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01140';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01141';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01142';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01143';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01144';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01145';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01146';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01147';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01148';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM01149';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM037';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM038';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM1026';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM1047';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM273';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM274';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM275';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM277';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM278';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM280';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM281';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM284';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM285';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM290';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM297';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM420';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM423';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM424';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM437';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM500';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM775';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM850';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'IBM851';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM852';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM855';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM857';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM860';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM861';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM862';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM863';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM864';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM865';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM866';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM868';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM869';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM870';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM871';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM880';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM891';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM903';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM904';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM905';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IBM918';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IEC_P27-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'INIS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'INIS-8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'INIS-CYRILLIC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'INVARIANT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-10646-J-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-10646-UCS-4';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-10646-UCS-BASIC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-10646-UNICODE-LATIN1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-10646-UTF-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-2022-CN';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-2022-JP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-2022-JP-2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-2022-KR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-1';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-1-WINDOWS-3.0-';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-1-WINDOWS-3.1-';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-10';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-13';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-14';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-15';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-16';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-2';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-2-WINDOWS-LATI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-3';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-4';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-5';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-6';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-6-E';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-6-I';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-7';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-8';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-8-E';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-8-I';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-8859-9';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'ISO-8859-9-WINDOWS-LATI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-IR-90';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-UNICODE-IBM-1264';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-UNICODE-IBM-1265';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-UNICODE-IBM-1268';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO-UNICODE-IBM-1276';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_10367-BOX';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_2033-1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_5427';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_5427:1981';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_5428:1980';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_646.BASIC:1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_6937-2-25';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_6937-2-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'ISO_8859-SUPP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'IT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6220-1969-RO';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6226-1978';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6226-1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6229-1984-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6229-1984-B';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6229-1984-B-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6229-1984-HAND';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6229-1984-HAND-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_C6229-1984-KANA';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_ENCODING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JIS_X0212-1990';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JUS_I.B1.002';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JUS_I.B1.003-MAC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'JUS_I.B1.003-SERB';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'KOI7-SWITCHED';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'KOI8-R';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'KOI8-U';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'KSC5636';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'KS_C_5601-1987';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'LATIN-GREEK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'LATIN-GREEK-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'LATIN-LAP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'MACINTOSH';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'MICROSOFT-PUBLISHING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'MNEM';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'MSZ_7795.3';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NATS-DANO';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NATS-DANO-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NATS-SEFI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NATS-SEFI-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NC_NC00-10:81';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NF_Z_62-010';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NF_Z_62-010_(1973)';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NS_4551-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'NS_4551-2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'OSD_EBCDIC_DF03_IRV';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'OSD_EBCDIC_DF04_1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'OSD_EBCDIC_DF04_15';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'PC8-DANISH-NORWEGIAN';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'PC8-TURKISH';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'PT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'PT2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'PTCP154';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'SCSU';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'SEN_850200_B';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'SEN_850200_C';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'SHIFT_JIS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'T.101-G2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'T.61-7BIT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'T.61-8BIT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'TIS-620';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'UNICODE-1-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'UNICODE-1-1-UTF-7';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'UNKNOWN-8BIT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'US-ASCII';
  encoding: CHAR_ENCODING_BYTE
),
(
  setname:'US-DK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'UTF-16';
  encoding: CHAR_ENCODING_UTF16
),
(
  setname:'UTF-16BE';
  encoding: CHAR_ENCODING_UTF16BE
),
(
  setname:'UTF-16LE';
  encoding: CHAR_ENCODING_UTF16LE
),
(
  setname:'UTF-32';
  encoding: CHAR_ENCODING_UTF32
),
(
  setname:'UTF-32BE';
  encoding: CHAR_ENCODING_UTF32BE
),
(
  setname:'UTF-32LE';
  encoding: CHAR_ENCODING_UTF32LE
),
(
  setname:'UTF-7';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'UTF-8';
  encoding: CHAR_ENCODING_UTF8
),
(
  setname:'VENTURA-INTERNATIONAL';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'VENTURA-MATH';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'VENTURA-US';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'VIDEOTEX-SUPPL';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'VIQR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'VISCII';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1250';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1251';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1252';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1253';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1254';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1255';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1256';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1257';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-1258';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  setname:'WINDOWS-31J';
  encoding: CHAR_ENCODING_UNKNOWN
)
);
