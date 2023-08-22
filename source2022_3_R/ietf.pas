{
 ****************************************************************************
    $Id: ietf.pas,v 1.10 2006/08/31 03:06:56 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Unicode related routines
    Partially converted from: 
    http://www.unicode.org/Public/PROGRAMS/CVTUTF/

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codere)
    @abstract(ietf/web related support unit)

    This unit contains routines to validate
    strings, and characters according to different
    IETF standards (such as URL's, URI's and MIME types).
    
}
unit ietf;

interface

uses
 {tpautils,
 vpautils,
 dpautils,
 fpautils,
 gpautils }
 sysutils
 ;


 const
  MAX_ENTRIES =469;
type
  TLangInfo = record
    name_fr: string[64];
    name_en: string[64];
    code: string[2];
    biblio_code: string[3];
  end;



 const
  LangInfo: array[1..MAX_ENTRIES] of TLangInfo = (
  (
   name_fr: 'afar';
   name_en: 'Afar';
   code: 'aa';
   biblio_code: 'aar'
  ),
  (
   name_fr: 'abkhaze';
   name_en: 'Abkhazian';
   code: 'ab';
   biblio_code: 'abk'
  ),
  (
   name_fr: 'aceh';
   name_en: 'Achinese';
   code: '';
   biblio_code: 'ace'
  ),
  (
   name_fr: 'acoli';
   name_en: 'Acoli';
   code: '';
   biblio_code: 'ach'
  ),
  (
   name_fr: 'adangme';
   name_en: 'Adangme';
   code: '';
   biblio_code: 'ada'
  ),
  (
   name_fr: 'adyghe';
   name_en: 'Adyghe; Adygei';
   code: '';
   biblio_code: 'ady'
  ),
  (
   name_fr: 'afro-asiatiques, autres langues';
   name_en: 'Afro-Asiatic (Other)';
   code: '';
   biblio_code: 'afa'
  ),
  (
   name_fr: 'afrihili';
   name_en: 'Afrihili';
   code: '';
   biblio_code: 'afh'
  ),
  (
   name_fr: 'afrikaans';
   name_en: 'Afrikaans';
   code: 'af';
   biblio_code: 'afr'
  ),
  (
   name_fr: 'akan';
   name_en: 'Akan';
   code: 'ak';
   biblio_code: 'aka'
  ),
  (
   name_fr: 'akkadien';
   name_en: 'Akkadian';
   code: '';
   biblio_code: 'akk'
  ),
  (
   name_fr: 'albanais';
   name_en: 'Albanian';
   code: 'sq';
   biblio_code: 'alb'
  ),
  (
   name_fr: 'al'#233'oute';
   name_en: 'Aleut';
   code: '';
   biblio_code: 'ale'
  ),
  (
   name_fr: 'algonquines, langues';
   name_en: 'Algonquian languages';
   code: '';
   biblio_code: 'alg'
  ),
  (
   name_fr: 'amharique';
   name_en: 'Amharic';
   code: 'am';
   biblio_code: 'amh'
  ),
  (
   name_fr: 'anglo-saxon (ca.450-1100)';
   name_en: 'English, Old (ca.450-1100)';
   code: '';
   biblio_code: 'ang'
  ),
  (
   name_fr: 'apache';
   name_en: 'Apache languages';
   code: '';
   biblio_code: 'apa'
  ),
  (
   name_fr: 'arabe';
   name_en: 'Arabic';
   code: 'ar';
   biblio_code: 'ara'
  ),
  (
   name_fr: 'aram'#233'en';
   name_en: 'Aramaic';
   code: '';
   biblio_code: 'arc'
  ),
  (
   name_fr: 'aragonais';
   name_en: 'Aragonese';
   code: 'an';
   biblio_code: 'arg'
  ),
  (
   name_fr: 'arm'#233'nien';
   name_en: 'Armenian';
   code: 'hy';
   biblio_code: 'arm'
  ),
  (
   name_fr: 'araucan';
   name_en: 'Araucanian';
   code: '';
   biblio_code: 'arn'
  ),
  (
   name_fr: 'arapaho';
   name_en: 'Arapaho';
   code: '';
   biblio_code: 'arp'
  ),
  (
   name_fr: 'artificielles, autres langues';
   name_en: 'Artificial (Other)';
   code: '';
   biblio_code: 'art'
  ),
  (
   name_fr: 'arawak';
   name_en: 'Arawak';
   code: '';
   biblio_code: 'arw'
  ),
  (
   name_fr: 'assamais';
   name_en: 'Assamese';
   code: 'as';
   biblio_code: 'asm'
  ),
  (
   name_fr: 'asturien; bable';
   name_en: 'Asturian; Bable';
   code: '';
   biblio_code: 'ast'
  ),
  (
   name_fr: 'athapascanes, langues';
   name_en: 'Athapascan languages';
   code: '';
   biblio_code: 'ath'
  ),
  (
   name_fr: 'australiennes, langues';
   name_en: 'Australian languages';
   code: '';
   biblio_code: 'aus'
  ),
  (
   name_fr: 'avar';
   name_en: 'Avaric';
   code: 'av';
   biblio_code: 'ava'
  ),
  (
   name_fr: 'avestique';
   name_en: 'Avestan';
   code: 'ae';
   biblio_code: 'ave'
  ),
  (
   name_fr: 'awadhi';
   name_en: 'Awadhi';
   code: '';
   biblio_code: 'awa'
  ),
  (
   name_fr: 'aymara';
   name_en: 'Aymara';
   code: 'ay';
   biblio_code: 'aym'
  ),
  (
   name_fr: 'az'#233'ri';
   name_en: 'Azerbaijani';
   code: 'az';
   biblio_code: 'aze'
  ),
  (
   name_fr: 'banda';
   name_en: 'Banda';
   code: '';
   biblio_code: 'bad'
  ),
  (
   name_fr: 'bamil'#233'k'#233's, langues';
   name_en: 'Bamileke languages';
   code: '';
   biblio_code: 'bai'
  ),
  (
   name_fr: 'bachkir';
   name_en: 'Bashkir';
   code: 'ba';
   biblio_code: 'bak'
  ),
  (
   name_fr: 'baloutchi';
   name_en: 'Baluchi';
   code: '';
   biblio_code: 'bal'
  ),
  (
   name_fr: 'bambara';
   name_en: 'Bambara';
   code: 'bm';
   biblio_code: 'bam'
  ),
  (
   name_fr: 'balinais';
   name_en: 'Balinese';
   code: '';
   biblio_code: 'ban'
  ),
  (
   name_fr: 'basque';
   name_en: 'Basque';
   code: 'eu';
   biblio_code: 'baq'
  ),
  (
   name_fr: 'basa';
   name_en: 'Basa';
   code: '';
   biblio_code: 'bas'
  ),
  (
   name_fr: 'baltiques, autres langues';
   name_en: 'Baltic (Other)';
   code: '';
   biblio_code: 'bat'
  ),
  (
   name_fr: 'bedja';
   name_en: 'Beja';
   code: '';
   biblio_code: 'bej'
  ),
  (
   name_fr: 'bi'#233'lorusse';
   name_en: 'Belarusian';
   code: 'be';
   biblio_code: 'bel'
  ),
  (
   name_fr: 'bemba';
   name_en: 'Bemba';
   code: '';
   biblio_code: 'bem'
  ),
  (
   name_fr: 'bengali';
   name_en: 'Bengali';
   code: 'bn';
   biblio_code: 'ben'
  ),
  (
   name_fr: 'berb'#232'res, autres langues';
   name_en: 'Berber (Other)';
   code: '';
   biblio_code: 'ber'
  ),
  (
   name_fr: 'bhojpuri';
   name_en: 'Bhojpuri';
   code: '';
   biblio_code: 'bho'
  ),
  (
   name_fr: 'bihari';
   name_en: 'Bihari';
   code: 'bh';
   biblio_code: 'bih'
  ),
  (
   name_fr: 'bikol';
   name_en: 'Bikol';
   code: '';
   biblio_code: 'bik'
  ),
  (
   name_fr: 'bini';
   name_en: 'Bini';
   code: '';
   biblio_code: 'bin'
  ),
  (
   name_fr: 'bichlamar';
   name_en: 'Bislama';
   code: 'bi';
   biblio_code: 'bis'
  ),
  (
   name_fr: 'blackfoot';
   name_en: 'Siksika';
   code: '';
   biblio_code: 'bla'
  ),
  (
   name_fr: 'bantoues, autres langues';
   name_en: 'Bantu (Other)';
   code: '';
   biblio_code: 'bnt'
  ),
  (
   name_fr: 'bosniaque';
   name_en: 'Bosnian';
   code: 'bs';
   biblio_code: 'bos'
  ),
  (
   name_fr: 'braj';
   name_en: 'Braj';
   code: '';
   biblio_code: 'bra'
  ),
  (
   name_fr: 'breton';
   name_en: 'Breton';
   code: 'br';
   biblio_code: 'bre'
  ),
  (
   name_fr: 'batak (Indon'#233'sie)';
   name_en: 'Batak (Indonesia)';
   code: '';
   biblio_code: 'btk'
  ),
  (
   name_fr: 'bouriate';
   name_en: 'Buriat';
   code: '';
   biblio_code: 'bua'
  ),
  (
   name_fr: 'bugi';
   name_en: 'Buginese';
   code: '';
   biblio_code: 'bug'
  ),
  (
   name_fr: 'bulgare';
   name_en: 'Bulgarian';
   code: 'bg';
   biblio_code: 'bul'
  ),
  (
   name_fr: 'birman';
   name_en: 'Burmese';
   code: 'my';
   biblio_code: 'bur'
  ),
  (
   name_fr: 'blin; bilen';
   name_en: 'Blin; Bilin';
   code: '';
   biblio_code: 'byn'
  ),
  (
   name_fr: 'caddo';
   name_en: 'Caddo';
   code: '';
   biblio_code: 'cad'
  ),
  (
   name_fr: 'indiennes d''''Am'#233'rique centrale, autres langues';
   name_en: 'Central American Indian (Other)';
   code: '';
   biblio_code: 'cai'
  ),
  (
   name_fr: 'caribe';
   name_en: 'Carib';
   code: '';
   biblio_code: 'car'
  ),
  (
   name_fr: 'catalan; valencien';
   name_en: 'Catalan; Valencian';
   code: 'ca';
   biblio_code: 'cat'
  ),
  (
   name_fr: 'caucasiennes, autres langues';
   name_en: 'Caucasian (Other)';
   code: '';
   biblio_code: 'cau'
  ),
  (
   name_fr: 'cebuano';
   name_en: 'Cebuano';
   code: '';
   biblio_code: 'ceb'
  ),
  (
   name_fr: 'celtiques, autres langues';
   name_en: 'Celtic (Other)';
   code: '';
   biblio_code: 'cel'
  ),
  (
   name_fr: 'chamorro';
   name_en: 'Chamorro';
   code: 'ch';
   biblio_code: 'cha'
  ),
  (
   name_fr: 'chibcha';
   name_en: 'Chibcha';
   code: '';
   biblio_code: 'chb'
  ),
  (
   name_fr: 'tch'#233'tch'#232'ne';
   name_en: 'Chechen';
   code: 'ce';
   biblio_code: 'che'
  ),
  (
   name_fr: 'djaghataï';
   name_en: 'Chagatai';
   code: '';
   biblio_code: 'chg'
  ),
  (
   name_fr: 'chinois';
   name_en: 'Chinese';
   code: 'zh';
   biblio_code: 'chi'
  ),
  (
   name_fr: 'chuuk';
   name_en: 'Chuukese';
   code: '';
   biblio_code: 'chk'
  ),
  (
   name_fr: 'mari';
   name_en: 'Mari';
   code: '';
   biblio_code: 'chm'
  ),
  (
   name_fr: 'chinook, jargon';
   name_en: 'Chinook jargon';
   code: '';
   biblio_code: 'chn'
  ),
  (
   name_fr: 'choctaw';
   name_en: 'Choctaw';
   code: '';
   biblio_code: 'cho'
  ),
  (
   name_fr: 'chipewyan';
   name_en: 'Chipewyan';
   code: '';
   biblio_code: 'chp'
  ),
  (
   name_fr: 'cherokee';
   name_en: 'Cherokee';
   code: '';
   biblio_code: 'chr'
  ),
  (
   name_fr: 'slavon d'''''#233'glise; vieux slave; slavon liturgique; vieux bulgare';
   name_en: 'Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old';
   code: 'cu';
   biblio_code: 'chu'
  ),
  (
   name_fr: 'tchouvache';
   name_en: 'Chuvash';
   code: 'cv';
   biblio_code: 'chv'
  ),
  (
   name_fr: 'cheyenne';
   name_en: 'Cheyenne';
   code: '';
   biblio_code: 'chy'
  ),
  (
   name_fr: 'chames, langues';
   name_en: 'Chamic languages';
   code: '';
   biblio_code: 'cmc'
  ),
  (
   name_fr: 'copte';
   name_en: 'Coptic';
   code: '';
   biblio_code: 'cop'
  ),
  (
   name_fr: 'cornique';
   name_en: 'Cornish';
   code: 'kw';
   biblio_code: 'cor'
  ),
  (
   name_fr: 'corse';
   name_en: 'Corsican';
   code: 'co';
   biblio_code: 'cos'
  ),
  (
   name_fr: 'cr'#233'oles et pidgins anglais, autres';
   name_en: 'Creoles and pidgins, English based (Other)';
   code: '';
   biblio_code: 'cpe'
  ),
  (
   name_fr: 'cr'#233'oles et pidgins fran'#231'ais, autres';
   name_en: 'Creoles and pidgins, French-based (Other)';
   code: '';
   biblio_code: 'cpf'
  ),
  (
   name_fr: 'cr'#233'oles et pidgins portugais, autres';
   name_en: 'Creoles and pidgins, Portuguese-based (Other)';
   code: '';
   biblio_code: 'cpp'
  ),
  (
   name_fr: 'cree';
   name_en: 'Cree';
   code: 'cr';
   biblio_code: 'cre'
  ),
  (
   name_fr: 'tatar de Crim'#233'';
   name_en: 'Crimean Tatar; Crimean Turkish';
   code: '';
   biblio_code: 'crh'
  ),
  (
   name_fr: 'cr'#233'oles et pidgins divers';
   name_en: 'Creoles and pidgins (Other)';
   code: '';
   biblio_code: 'crp'
  ),
  (
   name_fr: 'kachoube';
   name_en: 'Kashubian';
   code: '';
   biblio_code: 'csb'
  ),
  (
   name_fr: 'couchitiques, autres langues';
   name_en: 'Cushitic (Other)';
   code: '';
   biblio_code: 'cus'
  ),
  (
   name_fr: 'tch'#232'que';
   name_en: 'Czech';
   code: 'cs';
   biblio_code: 'cze'
  ),
  (
   name_fr: 'dakota';
   name_en: 'Dakota';
   code: '';
   biblio_code: 'dak'
  ),
  (
   name_fr: 'danois';
   name_en: 'Danish';
   code: 'da';
   biblio_code: 'dan'
  ),
  (
   name_fr: 'dargwa';
   name_en: 'Dargwa';
   code: '';
   biblio_code: 'dar'
  ),
  (
   name_fr: 'dayak';
   name_en: 'Dayak';
   code: '';
   biblio_code: 'day'
  ),
  (
   name_fr: 'delaware';
   name_en: 'Delaware';
   code: '';
   biblio_code: 'del'
  ),
  (
   name_fr: 'esclave (athapascan)';
   name_en: 'Slave (Athapascan)';
   code: '';
   biblio_code: 'den'
  ),
  (
   name_fr: 'dogrib';
   name_en: 'Dogrib';
   code: '';
   biblio_code: 'dgr'
  ),
  (
   name_fr: 'dinka';
   name_en: 'Dinka';
   code: '';
   biblio_code: 'din'
  ),
  (
   name_fr: 'maldivien';
   name_en: 'Divehi';
   code: 'dv';
   biblio_code: 'div'
  ),
  (
   name_fr: 'dogri';
   name_en: 'Dogri';
   code: '';
   biblio_code: 'doi'
  ),
  (
   name_fr: 'dravidiennes, autres langues';
   name_en: 'Dravidian (Other)';
   code: '';
   biblio_code: 'dra'
  ),
  (
   name_fr: 'bas-sorabe';
   name_en: 'Lower Sorbian';
   code: '';
   biblio_code: 'dsb'
  ),
  (
   name_fr: 'douala';
   name_en: 'Duala';
   code: '';
   biblio_code: 'dua'
  ),
  (
   name_fr: 'n'#233'erlandais moyen (ca. 1050-1350)';
   name_en: 'Dutch, Middle (ca.1050-1350)';
   code: '';
   biblio_code: 'dum'
  ),
  (
   name_fr: 'n'#233'erlandais; flamand';
   name_en: 'Dutch; Flemish';
   code: 'nl';
   biblio_code: 'dut'
  ),
  (
   name_fr: 'dioula';
   name_en: 'Dyula';
   code: '';
   biblio_code: 'dyu'
  ),
  (
   name_fr: 'dzongkha';
   name_en: 'Dzongkha';
   code: 'dz';
   biblio_code: 'dzo'
  ),
  (
   name_fr: 'efik';
   name_en: 'Efik';
   code: '';
   biblio_code: 'efi'
  ),
  (
   name_fr: ''#233'gyptien';
   name_en: 'Egyptian (Ancient)';
   code: '';
   biblio_code: 'egy'
  ),
  (
   name_fr: 'ekajuk';
   name_en: 'Ekajuk';
   code: '';
   biblio_code: 'eka'
  ),
  (
   name_fr: ''#233'lamite';
   name_en: 'Elamite';
   code: '';
   biblio_code: 'elx'
  ),
  (
   name_fr: 'anglais';
   name_en: 'English';
   code: 'en';
   biblio_code: 'eng'
  ),
  (
   name_fr: 'anglais moyen (1100-1500)';
   name_en: 'English, Middle (1100-1500)';
   code: '';
   biblio_code: 'enm'
  ),
  (
   name_fr: 'esp'#233'ranto';
   name_en: 'Esperanto';
   code: 'eo';
   biblio_code: 'epo'
  ),
  (
   name_fr: 'estonien';
   name_en: 'Estonian';
   code: 'et';
   biblio_code: 'est'
  ),
  (
   name_fr: ''#233'w'#233'';
   name_en: 'Ewe';
   code: 'ee';
   biblio_code: 'ewe'
  ),
  (
   name_fr: ''#233'wondo';
   name_en: 'Ewondo';
   code: '';
   biblio_code: 'ewo'
  ),
  (
   name_fr: 'fang';
   name_en: 'Fang';
   code: '';
   biblio_code: 'fan'
  ),
  (
   name_fr: 'f'#233'roïen';
   name_en: 'Faroese';
   code: 'fo';
   biblio_code: 'fao'
  ),
  (
   name_fr: 'fanti';
   name_en: 'Fanti';
   code: '';
   biblio_code: 'fat'
  ),
  (
   name_fr: 'fidjien';
   name_en: 'Fijian';
   code: 'fj';
   biblio_code: 'fij'
  ),
  (
   name_fr: 'finnois';
   name_en: 'Finnish';
   code: 'fi';
   biblio_code: 'fin'
  ),
  (
   name_fr: 'finno-ougriennes, autres langues';
   name_en: 'Finno-Ugrian (Other)';
   code: '';
   biblio_code: 'fiu'
  ),
  (
   name_fr: 'fon';
   name_en: 'Fon';
   code: '';
   biblio_code: 'fon'
  ),
  (
   name_fr: 'fran'#231'ais';
   name_en: 'French';
   code: 'fr';
   biblio_code: 'fre'
  ),
  (
   name_fr: 'fran'#231'ais moyen (1400-1800)';
   name_en: 'French, Middle (ca.1400-1800)';
   code: '';
   biblio_code: 'frm'
  ),
  (
   name_fr: 'fran'#231'ais ancien (842-ca.1400)';
   name_en: 'French, Old (842-ca.1400)';
   code: '';
   biblio_code: 'fro'
  ),
  (
   name_fr: 'frison';
   name_en: 'Frisian';
   code: 'fy';
   biblio_code: 'fry'
  ),
  (
   name_fr: 'peul';
   name_en: 'Fulah';
   code: 'ff';
   biblio_code: 'ful'
  ),
  (
   name_fr: 'frioulan';
   name_en: 'Friulian';
   code: '';
   biblio_code: 'fur'
  ),
  (
   name_fr: 'ga';
   name_en: 'Ga';
   code: '';
   biblio_code: 'gaa'
  ),
  (
   name_fr: 'gayo';
   name_en: 'Gayo';
   code: '';
   biblio_code: 'gay'
  ),
  (
   name_fr: 'gbaya';
   name_en: 'Gbaya';
   code: '';
   biblio_code: 'gba'
  ),
  (
   name_fr: 'germaniques, autres langues';
   name_en: 'Germanic (Other)';
   code: '';
   biblio_code: 'gem'
  ),
  (
   name_fr: 'g'#233'orgien';
   name_en: 'Georgian';
   code: 'ka';
   biblio_code: 'geo'
  ),
  (
   name_fr: 'allemand';
   name_en: 'German';
   code: 'de';
   biblio_code: 'ger'
  ),
  (
   name_fr: 'gu'#232'ze';
   name_en: 'Geez';
   code: '';
   biblio_code: 'gez'
  ),
  (
   name_fr: 'kiribati';
   name_en: 'Gilbertese';
   code: '';
   biblio_code: 'gil'
  ),
  (
   name_fr: 'ga'#233'lique; ga'#233'lique '#233'cossais';
   name_en: 'Gaelic; Scottish Gaelic';
   code: 'gd';
   biblio_code: 'gla'
  ),
  (
   name_fr: 'irlandais';
   name_en: 'Irish';
   code: 'ga';
   biblio_code: 'gle'
  ),
  (
   name_fr: 'galicien';
   name_en: 'Gallegan';
   code: 'gl';
   biblio_code: 'glg'
  ),
  (
   name_fr: 'manx; mannois';
   name_en: 'Manx';
   code: 'gv';
   biblio_code: 'glv'
  ),
  (
   name_fr: 'allemand, moyen haut (ca. 1050-1500)';
   name_en: 'German, Middle High (ca.1050-1500)';
   code: '';
   biblio_code: 'gmh'
  ),
  (
   name_fr: 'allemand, vieux haut (ca. 750-1050)';
   name_en: 'German, Old High (ca.750-1050)';
   code: '';
   biblio_code: 'goh'
  ),
  (
   name_fr: 'gond';
   name_en: 'Gondi';
   code: '';
   biblio_code: 'gon'
  ),
  (
   name_fr: 'gorontalo';
   name_en: 'Gorontalo';
   code: '';
   biblio_code: 'gor'
  ),
  (
   name_fr: 'gothique';
   name_en: 'Gothic';
   code: '';
   biblio_code: 'got'
  ),
  (
   name_fr: 'grebo';
   name_en: 'Grebo';
   code: '';
   biblio_code: 'grb'
  ),
  (
   name_fr: 'grec ancien (jusqu'''''#224' 1453)';
   name_en: 'Greek, Ancient (to 1453)';
   code: '';
   biblio_code: 'grc'
  ),
  (
   name_fr: 'grec moderne (apr'#232's 1453)';
   name_en: 'Greek, Modern (1453-)';
   code: 'el';
   biblio_code: 'gre'
  ),
  (
   name_fr: 'guarani';
   name_en: 'Guarani';
   code: 'gn';
   biblio_code: 'grn'
  ),
  (
   name_fr: 'goudjrati';
   name_en: 'Gujarati';
   code: 'gu';
   biblio_code: 'guj'
  ),
  (
   name_fr: 'gwich´in';
   name_en: 'Gwich´in';
   code: '';
   biblio_code: 'gwi'
  ),
  (
   name_fr: 'haida';
   name_en: 'Haida';
   code: '';
   biblio_code: 'hai'
  ),
  (
   name_fr: 'haïtien; cr'#233'ole haïtien';
   name_en: 'Haitian; Haitian Creole';
   code: 'ht';
   biblio_code: 'hat'
  ),
  (
   name_fr: 'haoussa';
   name_en: 'Hausa';
   code: 'ha';
   biblio_code: 'hau'
  ),
  (
   name_fr: 'hawaïen';
   name_en: 'Hawaiian';
   code: '';
   biblio_code: 'haw'
  ),
  (
   name_fr: 'h'#233'breu';
   name_en: 'Hebrew';
   code: 'he';
   biblio_code: 'heb'
  ),
  (
   name_fr: 'herero';
   name_en: 'Herero';
   code: 'hz';
   biblio_code: 'her'
  ),
  (
   name_fr: 'hiligaynon';
   name_en: 'Hiligaynon';
   code: '';
   biblio_code: 'hil'
  ),
  (
   name_fr: 'himachali';
   name_en: 'Himachali';
   code: '';
   biblio_code: 'him'
  ),
  (
   name_fr: 'hindi';
   name_en: 'Hindi';
   code: 'hi';
   biblio_code: 'hin'
  ),
  (
   name_fr: 'hittite';
   name_en: 'Hittite';
   code: '';
   biblio_code: 'hit'
  ),
  (
   name_fr: 'hmong';
   name_en: 'Hmong';
   code: '';
   biblio_code: 'hmn'
  ),
  (
   name_fr: 'hiri motu';
   name_en: 'Hiri Motu';
   code: 'ho';
   biblio_code: 'hmo'
  ),
  (
   name_fr: 'haut-sorabe';
   name_en: 'Upper Sorbian';
   code: '';
   biblio_code: 'hsb'
  ),
  (
   name_fr: 'hongrois';
   name_en: 'Hungarian';
   code: 'hu';
   biblio_code: 'hun'
  ),
  (
   name_fr: 'hupa';
   name_en: 'Hupa';
   code: '';
   biblio_code: 'hup'
  ),
  (
   name_fr: 'iban';
   name_en: 'Iban';
   code: '';
   biblio_code: 'iba'
  ),
  (
   name_fr: 'igbo';
   name_en: 'Igbo';
   code: 'ig';
   biblio_code: 'ibo'
  ),
  (
   name_fr: 'islandais';
   name_en: 'Icelandic';
   code: 'is';
   biblio_code: 'ice'
  ),
  (
   name_fr: 'ido';
   name_en: 'Ido';
   code: 'io';
   biblio_code: 'ido'
  ),
  (
   name_fr: 'yi de Sichuan';
   name_en: 'Sichuan Yi';
   code: 'ii';
   biblio_code: 'iii'
  ),
  (
   name_fr: 'ijo';
   name_en: 'Ijo';
   code: '';
   biblio_code: 'ijo'
  ),
  (
   name_fr: 'inuktitut';
   name_en: 'Inuktitut';
   code: 'iu';
   biblio_code: 'iku'
  ),
  (
   name_fr: 'interlingue';
   name_en: 'Interlingue';
   code: 'ie';
   biblio_code: 'ile'
  ),
  (
   name_fr: 'ilocano';
   name_en: 'Iloko';
   code: '';
   biblio_code: 'ilo'
  ),
  (
   name_fr: 'interlingua (langue auxiliaire internationale)';
   name_en: 'Interlingua (International Auxiliary Language Association)';
   code: 'ia';
   biblio_code: 'ina'
  ),
  (
   name_fr: 'indo-aryennes, autres langues';
   name_en: 'Indic (Other)';
   code: '';
   biblio_code: 'inc'
  ),
  (
   name_fr: 'indon'#233'sien';
   name_en: 'Indonesian';
   code: 'id';
   biblio_code: 'ind'
  ),
  (
   name_fr: 'indo-europ'#233'ennes, autres langues';
   name_en: 'Indo-European (Other)';
   code: '';
   biblio_code: 'ine'
  ),
  (
   name_fr: 'ingouche';
   name_en: 'Ingush';
   code: '';
   biblio_code: 'inh'
  ),
  (
   name_fr: 'inupiaq';
   name_en: 'Inupiaq';
   code: 'ik';
   biblio_code: 'ipk'
  ),
  (
   name_fr: 'iraniennes, autres langues';
   name_en: 'Iranian (Other)';
   code: '';
   biblio_code: 'ira'
  ),
  (
   name_fr: 'iroquoises, langues (famille)';
   name_en: 'Iroquoian languages';
   code: '';
   biblio_code: 'iro'
  ),
  (
   name_fr: 'italien';
   name_en: 'Italian';
   code: 'it';
   biblio_code: 'ita'
  ),
  (
   name_fr: 'javanais';
   name_en: 'Javanese';
   code: 'jv';
   biblio_code: 'jav'
  ),
  (
   name_fr: 'lojban';
   name_en: 'Lojban';
   code: '';
   biblio_code: 'jbo'
  ),
  (
   name_fr: 'japonais';
   name_en: 'Japanese';
   code: 'ja';
   biblio_code: 'jpn'
  ),
  (
   name_fr: 'jud'#233'o-persan';
   name_en: 'Judeo-Persian';
   code: '';
   biblio_code: 'jpr'
  ),
  (
   name_fr: 'jud'#233'o-arabe';
   name_en: 'Judeo-Arabic';
   code: '';
   biblio_code: 'jrb'
  ),
  (
   name_fr: 'karakalpak';
   name_en: 'Kara-Kalpak';
   code: '';
   biblio_code: 'kaa'
  ),
  (
   name_fr: 'kabyle';
   name_en: 'Kabyle';
   code: '';
   biblio_code: 'kab'
  ),
  (
   name_fr: 'kachin';
   name_en: 'Kachin';
   code: '';
   biblio_code: 'kac'
  ),
  (
   name_fr: 'groenlandais';
   name_en: 'Kalaallisut; Greenlandic';
   code: 'kl';
   biblio_code: 'kal'
  ),
  (
   name_fr: 'kamba';
   name_en: 'Kamba';
   code: '';
   biblio_code: 'kam'
  ),
  (
   name_fr: 'kannada';
   name_en: 'Kannada';
   code: 'kn';
   biblio_code: 'kan'
  ),
  (
   name_fr: 'karen';
   name_en: 'Karen';
   code: '';
   biblio_code: 'kar'
  ),
  (
   name_fr: 'kashmiri';
   name_en: 'Kashmiri';
   code: 'ks';
   biblio_code: 'kas'
  ),
  (
   name_fr: 'kanouri';
   name_en: 'Kanuri';
   code: 'kr';
   biblio_code: 'kau'
  ),
  (
   name_fr: 'kawi';
   name_en: 'Kawi';
   code: '';
   biblio_code: 'kaw'
  ),
  (
   name_fr: 'kazakh';
   name_en: 'Kazakh';
   code: 'kk';
   biblio_code: 'kaz'
  ),
  (
   name_fr: 'kabardien';
   name_en: 'Kabardian';
   code: '';
   biblio_code: 'kbd'
  ),
  (
   name_fr: 'khasi';
   name_en: 'Khasi';
   code: '';
   biblio_code: 'kha'
  ),
  (
   name_fr: 'khoisan, autres langues';
   name_en: 'Khoisan (Other)';
   code: '';
   biblio_code: 'khi'
  ),
  (
   name_fr: 'khmer';
   name_en: 'Khmer';
   code: 'km';
   biblio_code: 'khm'
  ),
  (
   name_fr: 'khotanais';
   name_en: 'Khotanese';
   code: '';
   biblio_code: 'kho'
  ),
  (
   name_fr: 'kikuyu';
   name_en: 'Kikuyu; Gikuyu';
   code: 'ki';
   biblio_code: 'kik'
  ),
  (
   name_fr: 'rwanda';
   name_en: 'Kinyarwanda';
   code: 'rw';
   biblio_code: 'kin'
  ),
  (
   name_fr: 'kirghize';
   name_en: 'Kirghiz';
   code: 'ky';
   biblio_code: 'kir'
  ),
  (
   name_fr: 'kimbundu';
   name_en: 'Kimbundu';
   code: '';
   biblio_code: 'kmb'
  ),
  (
   name_fr: 'konkani';
   name_en: 'Konkani';
   code: '';
   biblio_code: 'kok'
  ),
  (
   name_fr: 'kom';
   name_en: 'Komi';
   code: 'kv';
   biblio_code: 'kom'
  ),
  (
   name_fr: 'kongo';
   name_en: 'Kongo';
   code: 'kg';
   biblio_code: 'kon'
  ),
  (
   name_fr: 'cor'#233'en';
   name_en: 'Korean';
   code: 'ko';
   biblio_code: 'kor'
  ),
  (
   name_fr: 'kosrae';
   name_en: 'Kosraean';
   code: '';
   biblio_code: 'kos'
  ),
  (
   name_fr: 'kpell'#233'';
   name_en: 'Kpelle';
   code: '';
   biblio_code: 'kpe'
  ),
  (
   name_fr: 'karatchai balkar';
   name_en: 'Karachay-Balkar';
   code: '';
   biblio_code: 'krc'
  ),
  (
   name_fr: 'krou';
   name_en: 'Kru';
   code: '';
   biblio_code: 'kro'
  ),
  (
   name_fr: 'kurukh';
   name_en: 'Kurukh';
   code: '';
   biblio_code: 'kru'
  ),
  (
   name_fr: 'kuanyama; kwanyama';
   name_en: 'Kuanyama; Kwanyama';
   code: 'kj';
   biblio_code: 'kua'
  ),
  (
   name_fr: 'koumyk';
   name_en: 'Kumyk';
   code: '';
   biblio_code: 'kum'
  ),
  (
   name_fr: 'kurde';
   name_en: 'Kurdish';
   code: 'ku';
   biblio_code: 'kur'
  ),
  (
   name_fr: 'kutenai';
   name_en: 'Kutenai';
   code: '';
   biblio_code: 'kut'
  ),
  (
   name_fr: 'jud'#233'o-espagnol';
   name_en: 'Ladino';
   code: '';
   biblio_code: 'lad'
  ),
  (
   name_fr: 'lahnda';
   name_en: 'Lahnda';
   code: '';
   biblio_code: 'lah'
  ),
  (
   name_fr: 'lamba';
   name_en: 'Lamba';
   code: '';
   biblio_code: 'lam'
  ),
  (
   name_fr: 'lao';
   name_en: 'Lao';
   code: 'lo';
   biblio_code: 'lao'
  ),
  (
   name_fr: 'latin';
   name_en: 'Latin';
   code: 'la';
   biblio_code: 'lat'
  ),
  (
   name_fr: 'letton';
   name_en: 'Latvian';
   code: 'lv';
   biblio_code: 'lav'
  ),
  (
   name_fr: 'lezghien';
   name_en: 'Lezghian';
   code: '';
   biblio_code: 'lez'
  ),
  (
   name_fr: 'limbourgeois';
   name_en: 'Limburgan; Limburger; Limburgish';
   code: 'li';
   biblio_code: 'lim'
  ),
  (
   name_fr: 'lingala';
   name_en: 'Lingala';
   code: 'ln';
   biblio_code: 'lin'
  ),
  (
   name_fr: 'lituanien';
   name_en: 'Lithuanian';
   code: 'lt';
   biblio_code: 'lit'
  ),
  (
   name_fr: 'mongo';
   name_en: 'Mongo';
   code: '';
   biblio_code: 'lol'
  ),
  (
   name_fr: 'lozi';
   name_en: 'Lozi';
   code: '';
   biblio_code: 'loz'
  ),
  (
   name_fr: 'luxembourgeois';
   name_en: 'Luxembourgish; Letzeburgesch';
   code: 'lb';
   biblio_code: 'ltz'
  ),
  (
   name_fr: 'luba-lulua';
   name_en: 'Luba-Lulua';
   code: '';
   biblio_code: 'lua'
  ),
  (
   name_fr: 'luba-katanga';
   name_en: 'Luba-Katanga';
   code: 'lu';
   biblio_code: 'lub'
  ),
  (
   name_fr: 'ganda';
   name_en: 'Ganda';
   code: 'lg';
   biblio_code: 'lug'
  ),
  (
   name_fr: 'luiseno';
   name_en: 'Luiseno';
   code: '';
   biblio_code: 'lui'
  ),
  (
   name_fr: 'lunda';
   name_en: 'Lunda';
   code: '';
   biblio_code: 'lun'
  ),
  (
   name_fr: 'luo (Kenya et Tanzanie)';
   name_en: 'Luo (Kenya and Tanzania)';
   code: '';
   biblio_code: 'luo'
  ),
  (
   name_fr: 'Lushai';
   name_en: 'lushai';
   code: '';
   biblio_code: 'lus'
  ),
  (
   name_fr: 'mac'#233'donien';
   name_en: 'Macedonian';
   code: 'mk';
   biblio_code: 'mac'
  ),
  (
   name_fr: 'madourais';
   name_en: 'Madurese';
   code: '';
   biblio_code: 'mad'
  ),
  (
   name_fr: 'magahi';
   name_en: 'Magahi';
   code: '';
   biblio_code: 'mag'
  ),
  (
   name_fr: 'marshall';
   name_en: 'Marshallese';
   code: 'mh';
   biblio_code: 'mah'
  ),
  (
   name_fr: 'maithili';
   name_en: 'Maithili';
   code: '';
   biblio_code: 'mai'
  ),
  (
   name_fr: 'makassar';
   name_en: 'Makasar';
   code: '';
   biblio_code: 'mak'
  ),
  (
   name_fr: 'malayalam';
   name_en: 'Malayalam';
   code: 'ml';
   biblio_code: 'mal'
  ),
  (
   name_fr: 'mandingue';
   name_en: 'Mandingo';
   code: '';
   biblio_code: 'man'
  ),
  (
   name_fr: 'maori';
   name_en: 'Maori';
   code: 'mi';
   biblio_code: 'mao'
  ),
  (
   name_fr: 'malayo-polyn'#233'siennes, autres langues';
   name_en: 'Austronesian (Other)';
   code: '';
   biblio_code: 'map'
  ),
  (
   name_fr: 'marathe';
   name_en: 'Marathi';
   code: 'mr';
   biblio_code: 'mar'
  ),
  (
   name_fr: 'massaï';
   name_en: 'Masai';
   code: '';
   biblio_code: 'mas'
  ),
  (
   name_fr: 'malais';
   name_en: 'Malay';
   code: 'ms';
   biblio_code: 'may'
  ),
  (
   name_fr: 'moksa';
   name_en: 'Moksha';
   code: '';
   biblio_code: 'mdf'
  ),
  (
   name_fr: 'mandar';
   name_en: 'Mandar';
   code: '';
   biblio_code: 'mdr'
  ),
  (
   name_fr: 'mend'#233'';
   name_en: 'Mende';
   code: '';
   biblio_code: 'men'
  ),
  (
   name_fr: 'irlandais moyen (900-1200)';
   name_en: 'Irish, Middle (900-1200)';
   code: '';
   biblio_code: 'mga'
  ),
  (
   name_fr: 'micmac';
   name_en: 'Micmac';
   code: '';
   biblio_code: 'mic'
  ),
  (
   name_fr: 'minangkabau';
   name_en: 'Minangkabau';
   code: '';
   biblio_code: 'min'
  ),
  (
   name_fr: 'diverses, langues';
   name_en: 'Miscellaneous languages';
   code: '';
   biblio_code: 'mis'
  ),
  (
   name_fr: 'môn-khmer, autres langues';
   name_en: 'Mon-Khmer (Other)';
   code: '';
   biblio_code: 'mkh'
  ),
  (
   name_fr: 'malgache';
   name_en: 'Malagasy';
   code: 'mg';
   biblio_code: 'mlg'
  ),
  (
   name_fr: 'maltais';
   name_en: 'Maltese';
   code: 'mt';
   biblio_code: 'mlt'
  ),
  (
   name_fr: 'mandchou';
   name_en: 'Manchu';
   code: '';
   biblio_code: 'mnc'
  ),
  (
   name_fr: 'manipuri';
   name_en: 'Manipuri';
   code: '';
   biblio_code: 'mni'
  ),
  (
   name_fr: 'manobo, langues';
   name_en: 'Manobo languages';
   code: '';
   biblio_code: 'mno'
  ),
  (
   name_fr: 'mohawk';
   name_en: 'Mohawk';
   code: '';
   biblio_code: 'moh'
  ),
  (
   name_fr: 'moldave';
   name_en: 'Moldavian';
   code: 'mo';
   biblio_code: 'mol'
  ),
  (
   name_fr: 'mongol';
   name_en: 'Mongolian';
   code: 'mn';
   biblio_code: 'mon'
  ),
  (
   name_fr: 'mor'#233'';
   name_en: 'Mossi';
   code: '';
   biblio_code: 'mos'
  ),
  (
   name_fr: 'multilingue';
   name_en: 'Multiple languages';
   code: '';
   biblio_code: 'mul'
  ),
  (
   name_fr: 'mounda, langues';
   name_en: 'Munda languages';
   code: '';
   biblio_code: 'mun'
  ),
  (
   name_fr: 'muskogee';
   name_en: 'Creek';
   code: '';
   biblio_code: 'mus'
  ),
  (
   name_fr: 'marvari';
   name_en: 'Marwari';
   code: '';
   biblio_code: 'mwr'
  ),
  (
   name_fr: 'maya, langues';
   name_en: 'Mayan languages';
   code: '';
   biblio_code: 'myn'
  ),
  (
   name_fr: 'erza';
   name_en: 'Erzya';
   code: '';
   biblio_code: 'myv'
  ),
  (
   name_fr: 'nahuatl';
   name_en: 'Nahuatl';
   code: '';
   biblio_code: 'nah'
  ),
  (
   name_fr: 'indiennes d''''Am'#233'rique du Nord, autres langues';
   name_en: 'North American Indian';
   code: '';
   biblio_code: 'nai'
  ),
  (
   name_fr: 'napolitain';
   name_en: 'Neapolitan';
   code: '';
   biblio_code: 'nap'
  ),
  (
   name_fr: 'nauruan';
   name_en: 'Nauru';
   code: 'na';
   biblio_code: 'nau'
  ),
  (
   name_fr: 'navaho';
   name_en: 'Navajo; Navaho';
   code: 'nv';
   biblio_code: 'nav'
  ),
  (
   name_fr: 'nd'#233'b'#233'l'#233' du Sud';
   name_en: 'Ndebele, South; South Ndebele';
   code: 'nr';
   biblio_code: 'nbl'
  ),
  (
   name_fr: 'nd'#233'b'#233'l'#233' du Nord';
   name_en: 'Ndebele, North; North Ndebele';
   code: 'nd';
   biblio_code: 'nde'
  ),
  (
   name_fr: 'ndonga';
   name_en: 'Ndonga';
   code: 'ng';
   biblio_code: 'ndo'
  ),
  (
   name_fr: 'bas allemand; bas saxon; allemand, bas; saxon, bas';
   name_en: 'Low German; Low Saxon; German, Low; Saxon, Low';
   code: '';
   biblio_code: 'nds'
  ),
  (
   name_fr: 'n'#233'palais';
   name_en: 'Nepali';
   code: 'ne';
   biblio_code: 'nep'
  ),
  (
   name_fr: 'nepal bhasa; newari';
   name_en: 'Nepal Bhasa; Newari';
   code: '';
   biblio_code: 'new'
  ),
  (
   name_fr: 'nias';
   name_en: 'Nias';
   code: '';
   biblio_code: 'nia'
  ),
  (
   name_fr: 'nig'#233'ro-congolaises, autres langues';
   name_en: 'Niger-Kordofanian (Other)';
   code: '';
   biblio_code: 'nic'
  ),
  (
   name_fr: 'niu'#233'';
   name_en: 'Niuean';
   code: '';
   biblio_code: 'niu'
  ),
  (
   name_fr: 'norv'#233'gien nynorsk; nynorsk, norv'#233'gien';
   name_en: 'Norwegian Nynorsk; Nynorsk, Norwegian';
   code: 'nn';
   biblio_code: 'nno'
  ),
  (
   name_fr: 'norv'#233'gien bokmål; bokmål, norv'#233'gien';
   name_en: 'Norwegian Bokmål; Bokmål, Norwegian';
   code: 'nb';
   biblio_code: 'nob'
  ),
  (
   name_fr: 'nogaï; nogay';
   name_en: 'Nogai';
   code: '';
   biblio_code: 'nog'
  ),
  (
   name_fr: 'norrois, vieux';
   name_en: 'Norse, Old';
   code: '';
   biblio_code: 'non'
  ),
  (
   name_fr: 'norv'#233'gien';
   name_en: 'Norwegian';
   code: 'no';
   biblio_code: 'nor'
  ),
  (
   name_fr: 'sotho du Nord';
   name_en: 'Sotho, Northern';
   code: '';
   biblio_code: 'nso'
  ),
  (
   name_fr: 'nubiennes, langues';
   name_en: 'Nubian languages';
   code: '';
   biblio_code: 'nub'
  ),
  (
   name_fr: 'newari classique';
   name_en: 'Classical Newari; Old Newari; Classical Nepal Bhasa';
   code: '';
   biblio_code: 'nwc'
  ),
  (
   name_fr: 'chichewa; chewa; nyanja';
   name_en: 'Chichewa; Chewa; Nyanja';
   code: 'ny';
   biblio_code: 'nya'
  ),
  (
   name_fr: 'nyamwezi';
   name_en: 'Nyamwezi';
   code: '';
   biblio_code: 'nym'
  ),
  (
   name_fr: 'nyankol'#233'';
   name_en: 'Nyankole';
   code: '';
   biblio_code: 'nyn'
  ),
  (
   name_fr: 'nyoro';
   name_en: 'Nyoro';
   code: '';
   biblio_code: 'nyo'
  ),
  (
   name_fr: 'nzema';
   name_en: 'Nzima';
   code: '';
   biblio_code: 'nzi'
  ),
  (
   name_fr: 'occitan (apr'#232's 1500); proven'#231'al';
   name_en: 'Occitan (post 1500); Proven'#231'al';
   code: 'oc';
   biblio_code: 'oci'
  ),
  (
   name_fr: 'ojibwa';
   name_en: 'Ojibwa';
   code: 'oj';
   biblio_code: 'oji'
  ),
  (
   name_fr: 'oriya';
   name_en: 'Oriya';
   code: 'or';
   biblio_code: 'ori'
  ),
  (
   name_fr: 'galla';
   name_en: 'Oromo';
   code: 'om';
   biblio_code: 'orm'
  ),
  (
   name_fr: 'osage';
   name_en: 'Osage';
   code: '';
   biblio_code: 'osa'
  ),
  (
   name_fr: 'oss'#232'te';
   name_en: 'Ossetian; Ossetic';
   code: 'os';
   biblio_code: 'oss'
  ),
  (
   name_fr: 'turc ottoman (1500-1928)';
   name_en: 'Turkish, Ottoman (1500-1928)';
   code: '';
   biblio_code: 'ota'
  ),
  (
   name_fr: 'otomangue, langues';
   name_en: 'Otomian languages';
   code: '';
   biblio_code: 'oto'
  ),
  (
   name_fr: 'papoues, autres langues';
   name_en: 'Papuan (Other)';
   code: '';
   biblio_code: 'paa'
  ),
  (
   name_fr: 'pangasinan';
   name_en: 'Pangasinan';
   code: '';
   biblio_code: 'pag'
  ),
  (
   name_fr: 'pahlavi';
   name_en: 'Pahlavi';
   code: '';
   biblio_code: 'pal'
  ),
  (
   name_fr: 'pampangan';
   name_en: 'Pampanga';
   code: '';
   biblio_code: 'pam'
  ),
  (
   name_fr: 'pendjabi';
   name_en: 'Panjabi; Punjabi';
   code: 'pa';
   biblio_code: 'pan'
  ),
  (
   name_fr: 'papiamento';
   name_en: 'Papiamento';
   code: '';
   biblio_code: 'pap'
  ),
  (
   name_fr: 'palau';
   name_en: 'Palauan';
   code: '';
   biblio_code: 'pau'
  ),
  (
   name_fr: 'perse, vieux (ca. 600-400 av. J.-C.)';
   name_en: 'Persian, Old (ca.600-400 B.C.)';
   code: '';
   biblio_code: 'peo'
  ),
  (
   name_fr: 'persan';
   name_en: 'Persian';
   code: 'fa';
   biblio_code: 'per'
  ),
  (
   name_fr: 'philippines, autres langues';
   name_en: 'Philippine (Other)';
   code: '';
   biblio_code: 'phi'
  ),
  (
   name_fr: 'ph'#233'nicien';
   name_en: 'Phoenician';
   code: '';
   biblio_code: 'phn'
  ),
  (
   name_fr: 'pali';
   name_en: 'Pali';
   code: 'pi';
   biblio_code: 'pli'
  ),
  (
   name_fr: 'polonais';
   name_en: 'Polish';
   code: 'pl';
   biblio_code: 'pol'
  ),
  (
   name_fr: 'pohnpei';
   name_en: 'Pohnpeian';
   code: '';
   biblio_code: 'pon'
  ),
  (
   name_fr: 'portugais';
   name_en: 'Portuguese';
   code: 'pt';
   biblio_code: 'por'
  ),
  (
   name_fr: 'prâkrit';
   name_en: 'Prakrit languages';
   code: '';
   biblio_code: 'pra'
  ),
  (
   name_fr: 'proven'#231'al ancien (jusqu'''''#224' 1500)';
   name_en: 'Proven'#231'al, Old (to 1500)';
   code: '';
   biblio_code: 'pro'
  ),
  (
   name_fr: 'pachto';
   name_en: 'Pushto';
   code: 'ps';
   biblio_code: 'pus'
  ),
  (
   name_fr: 'r'#233'serv'#233'e '#224' l''''usage local';
   name_en: 'Reserved for local use';
   code: '';
   biblio_code: 'qaa'
  ),
  (
   name_fr: 'quechua';
   name_en: 'Quechua';
   code: 'qu';
   biblio_code: 'que'
  ),
  (
   name_fr: 'rajasthani';
   name_en: 'Rajasthani';
   code: '';
   biblio_code: 'raj'
  ),
  (
   name_fr: 'rapanui';
   name_en: 'Rapanui';
   code: '';
   biblio_code: 'rap'
  ),
  (
   name_fr: 'rarotonga';
   name_en: 'Rarotongan';
   code: '';
   biblio_code: 'rar'
  ),
  (
   name_fr: 'romanes, autres langues';
   name_en: 'Romance (Other)';
   code: '';
   biblio_code: 'roa'
  ),
  (
   name_fr: 'rh'#233'to-roman';
   name_en: 'Raeto-Romance';
   code: 'rm';
   biblio_code: 'roh'
  ),
  (
   name_fr: 'tsigane';
   name_en: 'Romany';
   code: '';
   biblio_code: 'rom'
  ),
  (
   name_fr: 'roumain';
   name_en: 'Romanian';
   code: 'ro';
   biblio_code: 'rum'
  ),
  (
   name_fr: 'rundi';
   name_en: 'Rundi';
   code: 'rn';
   biblio_code: 'run'
  ),
  (
   name_fr: 'russe';
   name_en: 'Russian';
   code: 'ru';
   biblio_code: 'rus'
  ),
  (
   name_fr: 'sandawe';
   name_en: 'Sandawe';
   code: '';
   biblio_code: 'sad'
  ),
  (
   name_fr: 'sango';
   name_en: 'Sango';
   code: 'sg';
   biblio_code: 'sag'
  ),
  (
   name_fr: 'iakoute';
   name_en: 'Yakut';
   code: '';
   biblio_code: 'sah'
  ),
  (
   name_fr: 'indiennes d''''Am'#233'rique du Sud, autres langues';
   name_en: 'South American Indian (Other)';
   code: '';
   biblio_code: 'sai'
  ),
  (
   name_fr: 'salish, langues';
   name_en: 'Salishan languages';
   code: '';
   biblio_code: 'sal'
  ),
  (
   name_fr: 'samaritain';
   name_en: 'Samaritan Aramaic';
   code: '';
   biblio_code: 'sam'
  ),
  (
   name_fr: 'sanskrit';
   name_en: 'Sanskrit';
   code: 'sa';
   biblio_code: 'san'
  ),
  (
   name_fr: 'sasak';
   name_en: 'Sasak';
   code: '';
   biblio_code: 'sas'
  ),
  (
   name_fr: 'santal';
   name_en: 'Santali';
   code: '';
   biblio_code: 'sat'
  ),
  (
   name_fr: 'serbe';
   name_en: 'Serbian';
   code: 'sr';
   biblio_code: '7sc'
  ),
  (
   name_fr: ''#233'cossais';
   name_en: 'Scots';
   code: '';
   biblio_code: 'sco'
  ),
  (
   name_fr: 'croate';
   name_en: 'Croatian';
   code: 'hr';
   biblio_code: 'scr'
  ),
  (
   name_fr: 'selkoupe';
   name_en: 'Selkup';
   code: '';
   biblio_code: 'sel'
  ),
  (
   name_fr: 's'#233'mitiques, autres langues';
   name_en: 'Semitic (Other)';
   code: '';
   biblio_code: 'sem'
  ),
  (
   name_fr: 'irlandais ancien (jusqu'''''#224' 900)';
   name_en: 'Irish, Old (to 900)';
   code: '';
   biblio_code: 'sga'
  ),
  (
   name_fr: 'langues des signes';
   name_en: 'Sign Languages';
   code: '';
   biblio_code: 'sgn'
  ),
  (
   name_fr: 'chan';
   name_en: 'Shan';
   code: '';
   biblio_code: 'shn'
  ),
  (
   name_fr: 'sidamo';
   name_en: 'Sidamo';
   code: '';
   biblio_code: 'sid'
  ),
  (
   name_fr: 'singhalais';
   name_en: 'Sinhalese';
   code: 'si';
   biblio_code: 'sin'
  ),
  (
   name_fr: 'sioux, langues';
   name_en: 'Siouan languages';
   code: '';
   biblio_code: 'sio'
  ),
  (
   name_fr: 'sino-tib'#233'taines, autres langues';
   name_en: 'Sino-Tibetan (Other)';
   code: '';
   biblio_code: 'sit'
  ),
  (
   name_fr: 'slaves, autres langues';
   name_en: 'Slavic (Other)';
   code: '';
   biblio_code: 'sla'
  ),
  (
   name_fr: 'slovaque';
   name_en: 'Slovak';
   code: 'sk';
   biblio_code: 'slo'
  ),
  (
   name_fr: 'slov'#232'ne';
   name_en: 'Slovenian';
   code: 'sl';
   biblio_code: 'slv'
  ),
  (
   name_fr: 'sami du Sud';
   name_en: 'Southern Sami';
   code: '';
   biblio_code: 'sma'
  ),
  (
   name_fr: 'sami du Nord';
   name_en: 'Northern Sami';
   code: 'se';
   biblio_code: 'sme'
  ),
  (
   name_fr: 'sami, autres langues';
   name_en: 'Sami languages (Other)';
   code: '';
   biblio_code: 'smi'
  ),
  (
   name_fr: 'sami de Lule';
   name_en: 'Lule Sami';
   code: '';
   biblio_code: 'smj'
  ),
  (
   name_fr: 'sami d''''Inari';
   name_en: 'Inari Sami';
   code: '';
   biblio_code: 'smn'
  ),
  (
   name_fr: 'samoan';
   name_en: 'Samoan';
   code: 'sm';
   biblio_code: 'smo'
  ),
  (
   name_fr: 'sami skolt';
   name_en: 'Skolt Sami';
   code: '';
   biblio_code: 'sms'
  ),
  (
   name_fr: 'shona';
   name_en: 'Shona';
   code: 'sn';
   biblio_code: 'sna'
  ),
  (
   name_fr: 'sindhi';
   name_en: 'Sindhi';
   code: 'sd';
   biblio_code: 'snd'
  ),
  (
   name_fr: 'sonink'#233'';
   name_en: 'Soninke';
   code: '';
   biblio_code: 'snk'
  ),
  (
   name_fr: 'sogdien';
   name_en: 'Sogdian';
   code: '';
   biblio_code: 'sog'
  ),
  (
   name_fr: 'somali';
   name_en: 'Somali';
   code: 'so';
   biblio_code: 'som'
  ),
  (
   name_fr: 'songhai';
   name_en: 'Songhai';
   code: '';
   biblio_code: 'son'
  ),
  (
   name_fr: 'sotho du Sud';
   name_en: 'Sotho, Southern';
   code: 'st';
   biblio_code: 'sot'
  ),
  (
   name_fr: 'espagnol; castillan';
   name_en: 'Spanish; Castilian';
   code: 'es';
   biblio_code: 'spa'
  ),
  (
   name_fr: 'sarde';
   name_en: 'Sardinian';
   code: 'sc';
   biblio_code: 'srd'
  ),
  (
   name_fr: 's'#233'r'#232're';
   name_en: 'Serer';
   code: '';
   biblio_code: 'srr'
  ),
  (
   name_fr: 'nilo-sahariennes, autres langues';
   name_en: 'Nilo-Saharan (Other)';
   code: '';
   biblio_code: 'ssa'
  ),
  (
   name_fr: 'swati';
   name_en: 'Swati';
   code: 'ss';
   biblio_code: 'ssw'
  ),
  (
   name_fr: 'sukuma';
   name_en: 'Sukuma';
   code: '';
   biblio_code: 'suk'
  ),
  (
   name_fr: 'soundanais';
   name_en: 'Sundanese';
   code: 'su';
   biblio_code: 'sun'
  ),
  (
   name_fr: 'soussou';
   name_en: 'Susu';
   code: '';
   biblio_code: 'sus'
  ),
  (
   name_fr: 'sum'#233'rien';
   name_en: 'Sumerian';
   code: '';
   biblio_code: 'sux'
  ),
  (
   name_fr: 'swahili';
   name_en: 'Swahili';
   code: 'sw';
   biblio_code: 'swa'
  ),
  (
   name_fr: 'su'#233'dois';
   name_en: 'Swedish';
   code: 'sv';
   biblio_code: 'swe'
  ),
  (
   name_fr: 'syriaque';
   name_en: 'Syriac';
   code: '';
   biblio_code: 'syr'
  ),
  (
   name_fr: 'tahitien';
   name_en: 'Tahitian';
   code: 'ty';
   biblio_code: 'tah'
  ),
  (
   name_fr: 'thaïes, autres langues';
   name_en: 'Tai (Other)';
   code: '';
   biblio_code: 'tai'
  ),
  (
   name_fr: 'tamoul';
   name_en: 'Tamil';
   code: 'ta';
   biblio_code: 'tam'
  ),
  (
   name_fr: 'tatar';
   name_en: 'Tatar';
   code: 'tt';
   biblio_code: 'tat'
  ),
  (
   name_fr: 't'#233'lougou';
   name_en: 'Telugu';
   code: 'te';
   biblio_code: 'tel'
  ),
  (
   name_fr: 'temne';
   name_en: 'Timne';
   code: '';
   biblio_code: 'tem'
  ),
  (
   name_fr: 'tereno';
   name_en: 'Tereno';
   code: '';
   biblio_code: 'ter'
  ),
  (
   name_fr: 'tetum';
   name_en: 'Tetum';
   code: '';
   biblio_code: 'tet'
  ),
  (
   name_fr: 'tadjik';
   name_en: 'Tajik';
   code: 'tg';
   biblio_code: 'tgk'
  ),
  (
   name_fr: 'tagalog';
   name_en: 'Tagalog';
   code: 'tl';
   biblio_code: 'tgl'
  ),
  (
   name_fr: 'thaï';
   name_en: 'Thai';
   code: 'th';
   biblio_code: 'tha'
  ),
  (
   name_fr: 'tib'#233'tain';
   name_en: 'Tibetan';
   code: 'bo';
   biblio_code: 'tib'
  ),
  (
   name_fr: 'tigr'#233'';
   name_en: 'Tigre';
   code: '';
   biblio_code: 'tig'
  ),
  (
   name_fr: 'tigrigna';
   name_en: 'Tigrinya';
   code: 'ti';
   biblio_code: 'tir'
  ),
  (
   name_fr: 'tiv';
   name_en: 'Tiv';
   code: '';
   biblio_code: 'tiv'
  ),
  (
   name_fr: 'tokelau';
   name_en: 'Tokelau';
   code: '';
   biblio_code: 'tkl'
  ),
  (
   name_fr: 'klingon';
   name_en: 'Klingon; tlhlngan-Hol';
   code: '';
   biblio_code: 'tlh'
  ),
  (
   name_fr: 'tlingit';
   name_en: 'Tlingit';
   code: '';
   biblio_code: 'tli'
  ),
  (
   name_fr: 'tamacheq';
   name_en: 'Tamashek';
   code: '';
   biblio_code: 'tmh'
  ),
  (
   name_fr: 'tonga (Nyasa)';
   name_en: 'Tonga (Nyasa)';
   code: '';
   biblio_code: 'tog'
  ),
  (
   name_fr: 'tongan ('#206'les Tonga)';
   name_en: 'Tonga (Tonga Islands)';
   code: 'to';
   biblio_code: 'ton'
  ),
  (
   name_fr: 'tok pisin';
   name_en: 'Tok Pisin';
   code: '';
   biblio_code: 'tpi'
  ),
  (
   name_fr: 'tsimshian';
   name_en: 'Tsimshian';
   code: '';
   biblio_code: 'tsi'
  ),
  (
   name_fr: 'tswana';
   name_en: 'Tswana';
   code: 'tn';
   biblio_code: 'tsn'
  ),
  (
   name_fr: 'tsonga';
   name_en: 'Tsonga';
   code: 'ts';
   biblio_code: 'tso'
  ),
  (
   name_fr: 'turkm'#232'ne';
   name_en: 'Turkmen';
   code: 'tk';
   biblio_code: 'tuk'
  ),
  (
   name_fr: 'tumbuka';
   name_en: 'Tumbuka';
   code: '';
   biblio_code: 'tum'
  ),
  (
   name_fr: 'tupi, langues';
   name_en: 'Tupi languages';
   code: '';
   biblio_code: 'tup'
  ),
  (
   name_fr: 'turc';
   name_en: 'Turkish';
   code: 'tr';
   biblio_code: 'tur'
  ),
  (
   name_fr: 'altaïques, autres langues';
   name_en: 'Altaic (Other)';
   code: '';
   biblio_code: 'tut'
  ),
  (
   name_fr: 'tuvalu';
   name_en: 'Tuvalu';
   code: '';
   biblio_code: 'tvl'
  ),
  (
   name_fr: 'twi';
   name_en: 'Twi';
   code: 'tw';
   biblio_code: 'twi'
  ),
  (
   name_fr: 'touva';
   name_en: 'Tuvinian';
   code: '';
   biblio_code: 'tyv'
  ),
  (
   name_fr: 'oudmourte';
   name_en: 'Udmurt';
   code: '';
   biblio_code: 'udm'
  ),
  (
   name_fr: 'ougaritique';
   name_en: 'Ugaritic';
   code: '';
   biblio_code: 'uga'
  ),
  (
   name_fr: 'ouïgour';
   name_en: 'Uighur';
   code: 'ug';
   biblio_code: 'uig'
  ),
  (
   name_fr: 'ukrainien';
   name_en: 'Ukrainian';
   code: 'uk';
   biblio_code: 'ukr'
  ),
  (
   name_fr: 'umbundu';
   name_en: 'Umbundu';
   code: '';
   biblio_code: 'umb'
  ),
  (
   name_fr: 'ind'#233'termin'#233'e';
   name_en: 'Undetermined';
   code: '';
   biblio_code: 'und'
  ),
  (
   name_fr: 'ourdou';
   name_en: 'Urdu';
   code: 'ur';
   biblio_code: 'urd'
  ),
  (
   name_fr: 'ouszbek';
   name_en: 'Uzbek';
   code: 'uz';
   biblio_code: 'uzb'
  ),
  (
   name_fr: 'vaï';
   name_en: 'Vai';
   code: '';
   biblio_code: 'vai'
  ),
  (
   name_fr: 'venda';
   name_en: 'Venda';
   code: 've';
   biblio_code: 'ven'
  ),
  (
   name_fr: 'vietnamien';
   name_en: 'Vietnamese';
   code: 'vi';
   biblio_code: 'vie'
  ),
  (
   name_fr: 'volapük';
   name_en: 'Volapük';
   code: 'vo';
   biblio_code: 'vol'
  ),
  (
   name_fr: 'vote';
   name_en: 'Votic';
   code: '';
   biblio_code: 'vot'
  ),
  (
   name_fr: 'wakashennes, langues';
   name_en: 'Wakashan languages';
   code: '';
   biblio_code: 'wak'
  ),
  (
   name_fr: 'walamo';
   name_en: 'Walamo';
   code: '';
   biblio_code: 'wal'
  ),
  (
   name_fr: 'waray';
   name_en: 'Waray';
   code: '';
   biblio_code: 'war'
  ),
  (
   name_fr: 'washo';
   name_en: 'Washo';
   code: '';
   biblio_code: 'was'
  ),
  (
   name_fr: 'gallois';
   name_en: 'Welsh';
   code: 'cy';
   biblio_code: 'wel'
  ),
  (
   name_fr: 'sorabes, langues';
   name_en: 'Sorbian languages';
   code: '';
   biblio_code: 'wen'
  ),
  (
   name_fr: 'wallon';
   name_en: 'Walloon';
   code: 'wa';
   biblio_code: 'wln'
  ),
  (
   name_fr: 'wolof';
   name_en: 'Wolof';
   code: 'wo';
   biblio_code: 'wol'
  ),
  (
   name_fr: 'kalmouk';
   name_en: 'Kalmyk';
   code: '';
   biblio_code: 'xal'
  ),
  (
   name_fr: 'xhosa';
   name_en: 'Xhosa';
   code: 'xh';
   biblio_code: 'xho'
  ),
  (
   name_fr: 'yao';
   name_en: 'Yao';
   code: '';
   biblio_code: 'yao'
  ),
  (
   name_fr: 'yapois';
   name_en: 'Yapese';
   code: '';
   biblio_code: 'yap'
  ),
  (
   name_fr: 'yiddish';
   name_en: 'Yiddish';
   code: 'yi';
   biblio_code: 'yid'
  ),
  (
   name_fr: 'yoruba';
   name_en: 'Yoruba';
   code: 'yo';
   biblio_code: 'yor'
  ),
  (
   name_fr: 'yupik, langues';
   name_en: 'Yupik languages';
   code: '';
   biblio_code: 'ypk'
  ),
  (
   name_fr: 'zapot'#232'que';
   name_en: 'Zapotec';
   code: '';
   biblio_code: 'zap'
  ),
  (
   name_fr: 'zenaga';
   name_en: 'Zenaga';
   code: '';
   biblio_code: 'zen'
  ),
  (
   name_fr: 'zhuang; chuang';
   name_en: 'Zhuang; Chuang';
   code: 'za';
   biblio_code: 'zha'
  ),
  (
   name_fr: 'zand'#233'';
   name_en: 'Zande';
   code: '';
   biblio_code: 'znd'
  ),
  (
   name_fr: 'zoulou';
   name_en: 'Zulu';
   code: 'zu';
   biblio_code: 'zul'
  ),
  (
   name_fr: 'zuni';
   name_en: 'Zuni';
   code: '';
   biblio_code: 'zun'
  )
);


{----------------- MIME related routines ----------------}

{** abstract(Validates the syntax of a MIME type) 

    This routine is used to validate if MIME content type
    signature consists of a constructed valid syntax. It
    does not validate if the MIME type is assigned or if
    it actually exists or not.
    
    @param(s MIME type signature to verify)
    @return(TRUE if the signature has valid syntax)
}
function mime_isvalidcontenttype(const s: shortstring): boolean;

{------- RFC 1766 (language tags) related routines --------}

function langtag_isvalid(const s: string): boolean;

function langtag_split(const s: string; var primary,sub: string): boolean;

{----------------- URI related routines ----------------}
const
  {** @exclude Suggested start delimiter character for an URI, c.f. RFC  2396 }
  URI_START_DELIMITER_CHAR = '<';
  {** @exclude Suggested end delimiter character for an URI, c.f. RFC  2396 }
  URI_END_DELIMITER_CHAR = '>';
  {** @exclude }
  URI_SCHEME_NAME_EMAIL = 'mailto';
  {** @exclude }
  URI_SCHEME_SEPARATOR = ':';
  

 {** @abstract(Extract information from an URI string)

     Given an URI complete absolute specification string, extract
     and return the scheme, authority, path and query
     components of the URI. The exact definition of
     these terms is specified in IETF RFC 2396.
     
     @param(url URI to check)
     @returns(FALSE if the URI is not valid, otherwise
       returns TRUE)
 }
 function uri_split(url: string; var scheme, authority,path, query: string): boolean;



{----------------- URN related routines ----------------}


{** @abstract(Verifies the validity of a complete URN string)

    This checks the conformance of the URN address. It
    is based on IETF RFC 2141.

    @returns(TRUE if this is a valid URN string)
}
function urn_isvalid(s: shortstring): boolean;

{function urn_split(var sig, nid, nss: string): boolean;}


{** This routine checks that the specified NID (namespace) is
    either registered to IANA, or that it is an experimental
    NID, as described in IETF RFC 2611. More assignment
    information can be obtained from:
    http://www.iana.org/assignments/urn-namespaces

    @returns(TRUE if this is a registered or experimental NID string)
}
function urn_isvalidnid(nid: string): boolean;

{** @abstract(Splits an URN string in its separate components)

    It is based on IETF RFC 2141.

    @param(urn Complete URN string to separate)
    @param(urnidstr Signature URN:)
    @param(nidstr Namespace identifier NID)
    @param(nssstr Namespace specific string NSS)
    @returns(TRUE if the operation was successfull, or
      FALSE if the URN is malformed)
}
function urn_split(urn:string; var urnidstr,nidstr,nssstr: string): boolean;

{** Splits a path string returned by uri_split into its
    individual components for URN. }
function urn_pathsplit(path: string; var namespace, nss: string): boolean;


{** Splits a path string returned by uri_split into its
    individual components for the http URI. }
 function http_pathsplit(path: string; var directory, name: string): boolean;
{** Splits a path string returned by uri_split into its
    individual components for the file URI. }
 function file_pathsplit(path: string; var directory, name: string): boolean;



implementation

uses xutils {,iso639};

const
 alphaupper = ['A'..'Z'];
 alphalower = ['a'..'z'];
 numeric    = ['0'..'9'];
 hex        = ['A'..'F','a'..'f'] + numeric;
 alphanumeric = alphaupper + alphalower + numeric;
 control    = [#00..#$1F,#$7F];

const
 NID_MAX_REG = 33;
 NID_IANA: array[1..NID_MAX_REG] of string[16] =
 (
  'IETF',
  'PIN',
  'ISSN',
  'OID',
  'NEWSML',
  'OASIS',
  'XMLORG',
  'PUBLICID',
  'ISBN',
  'NBN',
  'WEB3D',
  'MPEG',
  'MACE',
  'FIPA',
  'SWIFT',
  'LIBERTY',
  'IPTC',
  'UUID',
  'UCI',
  'CLEI',
  'TVA',
  'FDC', 
  'ISAN', 
  'NZL', 
  'OMA', 
  'IVIS', 
  'S1000D',
  'URN-1',
  'URN-2',
  'URN-3',
  'URN-4',
  'URN-5',
  'URN-6'
 );


const
 URI_PATH_SEPARATOR = '/';
 URI_QUERY_SEPARATOR = '?';
 URI_MAX_SCHEMES = 50;

 uri_schemes: array[1..URI_MAX_SCHEMES] of string[16] =
 (
  'ftp',
  'http',
  'gopher',
  URI_SCHEME_NAME_EMAIL,
  'news',
  'nntp',
  'telnet',
  'wais',
  'file',
  'prospero',
  'z39.50s',
  'z39.50r',
  'cid',
  'mid',
  'vemmi',
  'service',
  'imap',
  'nfs',
  'acap',
  'rtsp',
  'tip',
  'pop',
  'data',
  'dav',
  'opaquelocktoken',
  'sip',
  'sips',
  'tel',
  'fax',
  'modem',
  'ldap',
  'https',
  'soap.beep',
  'soap.beeps',
  'xmlrpc.beep',
  'xmlrpc.beeps',
  'urn',
  'go',
  'h323',
  'ipp',
  'tftp',
  'mupdate',
  'pres',
  'im',
  'mtqp',
  'iris.beep',
  'dict',
  'afs',
  'tn3270',
  'mailserver'
 );


 uri_scheme_chars = ['a'..'z','0'..'9','+','-','.'];
 uri_host_chars = ['a'..'z','0'..'9','.','-'];

function mime_isvalidcontenttype(const s: shortstring): boolean;
var
 idx: integer;
 typestr: string;
 subtypestr: string;
 i: integer;
begin
 mime_isvalidcontenttype:=false;
 idx:=pos('/',s);
 if idx = 0 then
   exit;
 typestr:=copy(s,1,idx-1);
 subtypestr:=copy(s,idx+1,length(s));
 for i:=1 to length(typestr) do
   begin
     if typestr[i] in 
       (control+[' ','(','/',')','<','>','@',';',':','\', '"','[',']','?','='])
     then
       exit;
   end;
 for i:=1 to length(subtypestr) do
   begin
     if subtypestr[i] in 
       (control+[' ','(','/',')','<','>','@',';',':','\', '"','[',']','?','='])
     then
       exit;
   end;
 mime_isvalidcontenttype:=true;
end;


{***********************************************************************
                            URM
***********************************************************************}

{ NID's can either start with X- for experimental
  versions, or are registered with the IANA.
}
function urn_isvalidnid(nid: string): boolean;
var
 i: integer;
begin
  urn_isvalidnid := false;
  nid:=upstring(nid);
  for i:=1 to NID_MAX_REG do
    begin
      if nid = NID_IANA[i] then
        begin
          urn_isvalidnid := true;
          exit;
        end;
    end;
  if pos('X-',nid) = 1 then
     begin
       for i:=3 to length(nid) do
          begin
            if not ((nid[i] in alphanumeric) or (nid[i] = '-')) then
               exit;
          end;
        urn_isvalidnid := true;
        exit;
     end;
end;


function urn_isvalid(s: shortstring): boolean;
const
 URN_MAGIC = 'URN:';
var
 urnid: string;
 nidstr: string;
 idx: integer;
 i: integer;
begin
 urn_isvalid := false;
 { verify the identifier }
 if length(s) < length(URN_MAGIC) then
   exit;
 urnid:=copy(s,1,4);
 delete(s,1,4);
 if upstring(urnid) <> URN_MAGIC then
   exit;
 { verify the NID }
 idx:=pos(':',s);
 if idx = 0 then
   exit;
 nidstr:=copy(s,1,idx-1);
 delete(s,1,idx);
 if length(nidstr) = 0 then
   exit;
 if not (nidstr[1] in alphanumeric) then
   exit;
 if (length(nidstr) > 31) or (length(nidstr) < 1) then
   exit;
 for i:=2 to length(nidstr) do
  begin
    if not ((nidstr[i] in alphanumeric) or (nidstr[i] = '-')) then
       exit;
  end;
 { verify the NSS }
 if length(s) = 0 then exit;
 for i:=1 to length(s) do
   begin
     if (s[i] in (alphanumeric+['(',')','+',',','-','.',':','=','@',';','$',
                   '_','!','*',''''])) then
       continue
     else
     { escape character }
     if s[i] = '%' then
       begin
         { check if not going beyond the bounds of the values }
         if (i+2) > length(s) then
           exit;
         if not (s[i+1] in hex) then
           exit;
         if not (s[i+2] in hex) then
           exit;
       end
     else
       exit;
   end;
   urn_isvalid:=true;
end;

 function urn_pathsplit(path: string; var namespace, nss: string): boolean;
 var
  idx: integer;
 begin
   { verify the NID }
   idx:=pos(':',path);
   namespace:=lowstring(copy(path,1,idx-1));
   delete(path,1,idx);
   nss:=path;
   urn_pathsplit:=true;
 end;



function urn_split(urn:string; var urnidstr,nidstr,nssstr: string): boolean;
var
 idx: integer;
begin
  if not urn_isvalid(urn) then
    begin
      urn_split := false;
      exit;
    end;
 urnidstr:=upstring(copy(urn,1,4));
 delete(urn,1,4);
 { verify the NID }
 idx:=pos(':',urn);
 nidstr:=upstring(copy(urn,1,idx-1));
 delete(urn,1,idx);
 nssstr:=urn;
 urn_split:=true;
end;


type
    tlangsets =  array[1..MAX_ENTRIES] of tlanginfo;
    plangsets = ^tlangsets;


var
    lang_info: plangsets;


function isvalidlangcode(s: shortstring): boolean;
var
 i: integer;
begin
  isvalidlangcode:=false;
  if (length(s) > 3) or (length(s) = 0) then
    exit;
  for i:=1 to MAX_ENTRIES do
    begin
      if Lang_Info^[i].code = s then
         begin
            isvalidlangcode:=true;
            exit;
         end
      else
      if Lang_Info^[i].biblio_code = s then
         begin
            isvalidlangcode:=true;
            exit;
         end;
    end;
end;




function langtag_split(const s: string; var primary,sub: string): boolean;
const
  LANGTAG_MAX_LENGTH = 17; { 8 Alpha + 8 aLPHA + SEPARATOR }
  PRIMARY_TAG_PRIVATE = 'x';
  PRIMARY_TAG_RESERVED= 'i';
var
 index: integer;
 i: integer;
begin
  primary:='';
  sub:='';
  langtag_split:=false;
  if length(s) > LANGTAG_MAX_LENGTH then
    exit;
  { ISO 639 code, i, or x }
  if (length(s) = 2) or (length(s) = 1) then
    begin
     primary:=lowstring(copy(s,1,length(s)));
     if (primary = PRIMARY_TAG_PRIVATE) or
         (primary = PRIMARY_TAG_RESERVED) or IsValidLangCode(primary) then
         begin
           langtag_split:=true;
           exit;
         end;

    end
  else
    begin
      { Is there a subtype separator ? }
      index:=pos('-',s);
      if index = 0 then
         exit;
      primary:=lowstring(copy(s,1,index-1));
      sub:=copy(s,index+1,length(s));
      if (primary = PRIMARY_TAG_PRIVATE) or
         (primary = PRIMARY_TAG_RESERVED) or IsValidLangCode(primary) then
        begin
          { Seems to be valid - now check the subtag,
            simply check if there is whitespace }
          for i:=1 to length(sub) do
            begin
              if sub[i] in whitespace then
                exit;
            end;
          langtag_split:=true;
          exit;
        end;
    end;
end;


function langtag_isvalid(const s: string): boolean;
var
 primary,sub: string;
begin
 langtag_isvalid:=langtag_split(s,primary,sub);
end;

{***********************************************************************
                            URI
***********************************************************************}

 {** Checks if the URL is conformant to the specification
     defined in IETFC RFC 1738.
     @param(scheme The scheme to check)
     @returns(TRUE if the scheme is valid, or false if
         the scheme has an invalid syntax).
 }
 function uri_isvalidscheme(scheme: string): boolean;
 var
  i: integer;
 begin
   scheme:=lowstring(scheme);
   uri_isvalidscheme:=false;
   for i:=1 to length(scheme) do
     begin
       if not (scheme[i] in uri_scheme_chars) then
          exit;
     end;
   uri_isvalidscheme:=true;
 end;

 function uri_isvalidhost(host: string): boolean;
 var
  i: integer;
 begin
   host:=lowstring(host);
   uri_isvalidhost:=false;
   for i:=1 to length(host) do
     begin
       if not (host[i] in uri_host_chars) then
          exit;
     end;
   uri_isvalidhost:=true;
 end;


 function uri_split(url: string; var scheme,
   authority,path, query: string): boolean;
 var
  idx: integer;
  i: integer;
  present_path: boolean;
  present_authority: boolean;
 begin
   path:='';
   scheme:='';
   path:='';
   authority:='';
   query:='';
   uri_split:=false;
   present_path:=false;
   present_authority:=false;
   { Verify if there is a scheme present }
   idx:=pos(':',url);
   { There is a scheme - extract it and check its validity }
   if idx > 1 then
     begin
       scheme:=copy(url,1,idx-1);
       delete(url,1,idx);
       { Determine the scheme type }
       scheme:=lowstring(scheme);
       uri_split:=uri_isvalidscheme(scheme);
       {********* Check presence of the authority **********}
       if pos('//',url) = 1 then
       begin
         { This seems to be valid! }
         delete(url,1,2);
         {** Extract the authority information }
         for i:=1 to length(url) do
           begin
             { The authority component is terminated
               by one of these characters }
             if url[i] in ['?','/'] then
                break;
             authority:=authority+url[i];
           end;
         { delete the authority part of the URI }
         delete(url,1,i-1);
         present_authority:=true;
       end;
       {********* Check presence path **********}
       idx:=pos(URI_PATH_SEPARATOR,url);
       if (idx = 1) then
       begin
            path:=url[1];
            {** Extract the path information }
            for i:=2 to length(url) do
             begin
               { The path component is terminated
                 by a query separator or end of string }
               if url[i] in ['?'] then
                  break;
               path:=path+url[i];
           end;
           delete(url,1,i-1);
           path:=trim(path);
           present_path:=true;
       end;
       {********* Check presence of query **********}
       { Query is only available if there is an     }
       { authority, or abs_path                     }
       idx:=pos(URI_QUERY_SEPARATOR,url);
       if (idx = 1) and (present_path or present_authority) then
         begin
           { Do not keep the query separator }
           query:=copy(url,idx+1,length(url));
           delete(url,idx,length(url));
           { Copy the actual name of the resource to
             access from the directories }
           query:=trim(query);
         end;
       {********* This is an opaque string **********}
       { If authority and path not present           }
       if (present_path=false) and (present_authority=false) then
         begin
           { Keep the path separator }
           path:=copy(url,idx,length(url));
           delete(url,idx,length(url));
           { Copy the actual name of the resource to
             access from the directories }
           path:=trim(path);
         end;
   end;
 end;

 function http_pathsplit(path: string; var directory, name: string): boolean;
 var
  i: integer;
 begin
   http_pathsplit:=true;
   directory:=trim(path);
   name:='';
   { This is probably a filename }
   if directory[length(directory)] <> URI_PATH_SEPARATOR then
     begin
       for i:=length(directory) downto 1 do
         begin
          if directory[i] = URI_PATH_SEPARATOR then
            break;
          name:=directory[i] + name;
         end;
       delete(directory,i,length(directory));
     end;
 end;

 function file_pathsplit(path: string; var directory, name: string): boolean;
 begin
    file_pathsplit:=http_pathsplit(path,directory,name);
 end;







end.

{
  $Log: ietf.pas,v $
  Revision 1.10  2006/08/31 03:06:56  carl
  + Better documentation
  + Updated URN Namespace identifiers to list of 2006-08-28.

  Revision 1.9  2006/02/11 16:54:50  carl
    * Bugfix with URI validation

  Revision 1.8  2005/01/08 21:37:45  carl
    + better comments

  Revision 1.7  2005/01/06 03:25:51  carl
    + uri validation and splitting routines, compatible with URL parsing

  Revision 1.6  2004/12/26 23:41:22  carl
    + added some separator constants

  Revision 1.5  2004/11/21 19:52:57  carl
    + some const parameters for strings
    - remove some warnings

  Revision 1.4  2004/11/09 03:53:27  carl
   + IETF RFC 1766 language code parsing routines

  Revision 1.3  2004/06/20 18:49:38  carl
    + added  GPC support

  Revision 1.2  2004/06/17 11:45:48  carl
    + added documentation

}