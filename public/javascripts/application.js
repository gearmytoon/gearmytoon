(function($) {
  // Make an element clickable by finding the first link it contains
  $.fn.clickable = function() {
    $(this).css({'opacity': '0.90'}).mouseover(function(){
      $(this).css({'cursor': 'pointer','opacity': '1.0'});
    }).mouseout(function() {
      $(this).css({'cursor': 'pointer','opacity': '0.90'});
    }).click(function(){
      window.location = $(this).find('a:first').attr('href');
    });
  }
  
  $.fn.loadComments = function() {
    var self = this;
    var comment_list = $(this).parents('#comment_list');
    $.get($(this).attr('href'), function(data) {
      var parent = comment_list;
      parent.html(data);
      parent.show();
    });
  }
  
  $(document).ready(function(){
    var tooltip_url = null;
    var current_tooltip = null;
    $('.with_tooltip').mouseenter(function(e){
      var self = this;
      current_tooltip = self;
      var new_tooltip_url = $(this).attr('href') + '/tooltip';
      if(tooltip_url!= new_tooltip_url)
      {
        $("#tooltip").html("")
        tooltip_url = new_tooltip_url;
        $.get(tooltip_url,function(data) {
          if(current_tooltip == self){
            $("#tooltip").html(data);
          }
        });
      }
      $("#tooltip").show();
    }).mousemove(function(e) {
      $("#tooltip").css('left', e.pageX + 10);
      $("#tooltip").css('top', e.pageY + 10);
    }).mouseleave(function() {
      $("#tooltip").hide();
    });

    $('.add_comment').click(function(){
      $('#new_comment').slideToggle();
    });
    
    $('#slot_select').change(function(){
      var filter_path = $("#slot_select option:selected").val();
      window.location = filter_path;
    });
    
    $('#character_realm').autocomplete(realms);
    $('#welcome .actions ul li:not(li.toon_search)').clickable();
    $('#welcome .actions ul li.toon_search form input[type=text]').example(function() { return $(this).prev('label').text(); }).prev('label').hide();

    $('form input[type=submit]').each(function(i,button) {
      var form = $(button).parents('form');
      var gearMeLink =  $('<a class="submit awesome large red"></a>').text($(button).attr('value')).click(function(){ $(form).submit(); });
      $(button).replaceWith(gearMeLink);
    });
    
    $("#commentable").loadComments();
    
    $('.character, #contact ul li').clickable();

    $('#character_refresh').everyTime(1000,function(i){
      $.getJSON($(this).attr('href'), function(data){
        if(data.status =! "new" || data.status != "being_refreshed"){
          window.location.reload();
        }
      });
    });

    $('#character_gearing').everyTime(1000,function(i){
      $.getJSON($(this).attr('href'), function(data){
        if(data.status == "geared"){
          window.location.reload();
        }
      });
    });

  });
})(jQuery);

var realms = [ "Aegwynn", "Aerie Peak", "Agamaggan", "Aggramar", "Ahn'Qiraj", "Al'Akir", "Alexstrasza", "Alleria", "Alonsus", "Aman'Thul", "Ambossar", "Anachronos", "Anetheron", "Antonidas", "Anub'arak", "Arak-arahm", "Arathi", "Arathor", "Archimonde", "Area 52", "Argent Dawn", "Arthas", "Arygos", "Aszune", "Auchindoun", "Azjol-Nerub", "Azshara", "Azuremyst", "Baelgun", "Balnazzar", "Blackhand", "Blackmoore", "Blackrock", "Blade's Edge", "Bladefist", "Bloodfeather", "Bloodhoof", "Bloodscalp", "Blutkessel", "Boulderfist", "Bronze Dragonflight", "Bronzebeard", "Burning Blade", "Burning Legion", "Burning Steppes", "C'Thun", "Chamber of the Aspects", "Chants éternels", "Cho'gall", "Chromaggus", "Colinas Pardas", "Confrérie du Thorium", "Conseil des Ombres", "Crushridge", "Culte de la Rive noire", "Daggerspine", "Dalaran", "Dalvengyr", "Darkmoon Faire", "Darksorrow", "Darkspear", "Das Konsortium", "Das Syndikat", "Deathwing", "Defias Brotherhood", "Dentarg", "Der abyssische Rat", "Der Mithrilorden", "Der Rat von Dalaran", "Destromath", "Dethecus", "Die Aldor", "Die Arguswacht", "Die ewige Wacht", "Die Nachtwache", "Die Silberne Hand", "Die Todeskrallen", "Doomhammer", "Draenor", "Dragonblight", "Dragonmaw", "Drak'thul", "Drek'Thar", "Dun Modr", "Dun Morogh", "Dunemaul", "Durotan", "Earthen Ring", "Echsenkessel", "Eitrigg", "Eldre'Thalas", "Elune", "Emerald Dream", "Emeriss", "Eonar", "Eredar", "Executus", "Exodar", "Festung der Stürme", "Fizzcrank", "Forscherliga", "Frostmane", "Frostmourne", "Frostwhisper", "Frostwolf", "Garona", "Garrosh", "Genjuros", "Ghostlands", "Gilneas", "Gorgonnash", "Grim Batol", "Gul'dan", "Hakkar", "Haomarush", "Hellfire", "Hellscream", "Hyjal", "Illidan", "Jaedenar", "Kael'thas", "Karazhan", "Kargath", "Kazzak", "Kel'Thuzad", "Khadgar", "Khaz Modan", "Khaz'goroth", "Kil'Jaeden", "Kilrogg", "Kirin Tor", "Kor'gall", "Krag'jin", "Krasus", "Kul Tiras", "Kult der Verdammten", "La Croisade écarlate", "Laughing Skull", "Les Clairvoyants", "Les Sentinelles", "Lightbringer", "Lightning's Blade", "Lordaeron", "Los Errantes", "Lothar", "Madmortem", "Magtheridon", "Mal'Ganis", "Malfurion", "Malorne", "Malygos", "Mannoroth", "Marécage de Zangar", "Mazrigos", "Medivh", "Minahonda", "Molten Core", "Moonglade", "Mug'thol", "Nagrand", "Nathrezim", "Naxxramas", "Nazjatar", "Nefarian", "Neptulon", "Ner'zhul", "Nera'thor", "Nethersturm", "Nordrassil", "Norgannon", "Nozdormu", "Onyxia", "Outland", "Perenolde", "Proudmoore", "Quel'Thalas", "Ragnaros", "Rajaxx", "Rashgarroth", "Ravencrest", "Ravenholdt", "Rexxar", "Runetotem", "Sanguino", "Sargeras", "Saurfang", "Scarshield Legion", "Sen'jin", "Shadow Moon", "Shadowsong", "Shattered Halls", "Shattered Hand", "Shattrath", "Shen'dralar", "Silvermoon", "Sinstralis", "Skullcrusher", "Spinebreaker", "Sporeggar", "Steamwheedle Cartel", "Stonemaul", "Stormrage", "Stormreaver", "Stormscale", "Sunstrider", "Suramar", "Sylvanas", "Taerar", "Talnivarr", "Tarren Mill", "Teldrassil", "Temple noir", "Terenas", "Terokkar", "Terrordar", "The Maelstrom", "The Sha'tar", "The Venture Co.", "Theradras", "Thrall", "Throk'Feroth", "Thunderhorn", "Tichondrius", "Tirion", "Todeswache", "Trollbane", "Turalyon", "Twilight's Hammer", "Twisting Nether", "Tyrande", "Uldaman", "Ulduar", "Uldum", "Un'Goro", "Varimathras", "Vashj", "Vek'lor", "Vek'nilash", "Vol'jin", "Warsong", "Wildhammer", "Wrathbringer", "Xavius", "Ysera", "Ysondre", "Zenedar", "Zirkel des Cenarius", "Zul'Jin", "Zuluhed", "Akama", "Altar of Storms", "Alterac Mountains", "Andorhal", "Anvilmar", "Azgalor", "Barthilas", "Black Dragonflight", "Blackwater Raiders", "Blackwing Lair", "Bleeding Hollow", "Blood Furnace", "Bonechewer", "Borean Tundra", "Caelestrasz", "Cairne", "Cenarion Circle", "Cenarius", "Coilfang", "Dark Iron", "Darrowmere", "Dath'Remar", "Dawnbringer", "Demon Soul", "Detheroc", "Drak'Tharon", "Draka", "Drakkari", "Dreadmaul", "Drenden", "Duskwood", "Echo Isles", "Farstriders", "Feathermoon", "Fenris", "Firetree", "Galakrond", "Garithos", "Gnomeregan", "Gorefiend", "Greymane", "Grizzly Hills", "Gundrak", "Gurubashi", "Hydraxis", "Icecrown", "Jubei'Thos", "Kalecgos", "Korgath", "Korialstraaz", "Lethon", "Lightninghoof", "Llane", "Madoran", "Maelstrom", "Maiev", "Misha", "Mok'Nathal", "Moon Guard", "Moonrunner", "Muradin", "Nazgrel", "Quel'dorei", "Rivendare", "Scarlet Crusade", "Scilla", "Sentinels", "Shadow Council", "Shandris", "Shu'halo", "Silver Hand", "Sisters of Elune", "Skywall", "Smolderthorn", "Spirestone", "Staghelm", "Tanaris", "Thaurissan", "The Forgotten Coast", "The Scryers", "The Underbog", "The Venture Co", "Thorium Brotherhood", "Thunderlord", "Tortheldrin", "Undermine", "Ursin", "Uther", "Velen", "Whisperwind", "Windrunner", "Winterhoof", "Wyrmrest Accord", "Zangarmarsh", "Zul'jin",
               "Азурегос", "Вечная Песня", "Гордунни", "Гром", "Дракономор", "Король-лич", "Пиратская бухта", "Подземье", "Разувий", "Свежеватель Душ", "Седогрив", "Страж смерти", "Термоштепсель", "Ткач Смерти", "Ясеневый лес",
               "가로나", "검은용군단", "굴단", "나스레짐", "넬'쥴", "노르가논", "달라란", "데스윙", "둠해머", "듀로탄", "드레노어", "라그나로스", "레엔", "렉사르", "마그테리돈", "만노로스", "말가니스", "말리고스", "말퓨리온", "메디브", "불타는 군단", "붉은용군단", "블랙무어", "살게라스", "세나리우스", "스톰레이지", "실바나스", "실버문", "아서스", "아스준", "아즈갈로", "아즈샤라", "아키몬드", "알레리아", "알렉스트라자", "에그윈", "엘룬", "와일드해머", "우서", "윈드러너", "이오나", "일리단", "줄진", "진홍십자군", "청동용군단", "카르가스", "캘타스", "켈투자드", "쿨 티라스", "킬로그", "킬제덴", "티콘드리우스", "하이잘", "헬스크림",
               "主宰之剑", "乌瑟尔", "伊利丹", "伊瑟拉", "众星之子", "克洛玛古斯", "克苏恩", "冬泉谷", "冰霜之刃", "匹瑞诺德", "卡德加", "卡德罗斯", "卡扎克", "卡拉赞", "古拉巴什", "吉安娜", "哈卡", "回音山", "回音群岛", "国王之谷", "图拉扬", "圣光之愿", "地狱咆哮", "埃加洛尔", "埃德萨拉", "埃苏雷格", "基尔罗格", "塔伦米尔", "塞纳留斯", "塞纳里奥", "夏维安", "夜空之歌", "奈法利安", "奎尔萨拉斯", "奥丹姆", "奥拉基尔", "奥特兰克", "奥蕾莉亚", "奥达曼", "安东尼达斯", "安其拉", "安威玛尔", "安纳塞隆", "尘风峡谷", "屠魔山谷", "山丘之王", "巴纳扎尔", "布瑞尔", "布莱克摩", "库尔提拉斯", "库德兰", "德拉诺", "战歌", "拉文凯斯", "拉文霍德", "拉格纳罗斯", "拉贾克斯", "无尽之海", "普瑞斯托", "暗影之月", "暴风祭坛", "月光林地", "月神殿", "杜隆坦", "格瑞姆巴托", "桑德兰", "梅尔加尼", "梦境之树", "森金", "死亡之翼", "毁灭之锤", "永恒之井", "泰兰德", "泰拉尔", "泰瑞纳斯", "洛丹伦", "洛萨", "海加尔", "海达希亚", "激流堡", "火焰之树", "灵魂石地", "烈焰峰", "熔火之心", "燃烧军团", "燃烧平原", "爱斯特纳", "玛多兰", "玛法里奥", "玛瑟里顿", "玛诺洛斯", "玛里苟斯", "瑞文戴尔", "瓦拉斯塔兹", "瓦里玛萨斯", "白银之手", "石爪峰", "破碎岭", "神谕林地", "符文图腾", "米莎", "索拉丁", "索瑞森", "红云台地", "红龙军团", "纳克萨玛斯", "纳斯雷兹姆", "罗宁", "耐奥祖", "耐普图隆", "耐萨里奥", "耳语海岸", "艾森娜", "艾欧纳尔", "艾苏恩", "艾萨拉", "艾露恩", "范达尔鹿盔", "莫德古得", "莱斯霜语", "莱索恩", "萨格拉斯", "萨菲隆", "蓝龙军团", "藏宝海湾", "血羽", "血色十字军", "诺莫瑞根", "诺达希尔", "轻风之语", "达拉然", "达斯雷玛", "达纳斯", "达隆米尔", "迦罗娜", "迪托马斯", "迷雾之海", "通灵学院", "遗忘海岸", "金色平原", "铜龙军团", "银月", "银松森林", "闪电之刃", "阿克蒙德", "阿努巴拉克", "阿尔萨斯", "阿拉希", "阿拉索", "阿格拉玛", "阿纳克洛斯", "阿迦玛甘", "雷克萨", "雷霆之怒", "雷霆之王", "霜之哀伤", "霜狼", "风暴之怒", "风行者", "鬼雾峰", "鹰巢山", "麦维影歌", "麦迪文", "黑手军团", "黑暗之矛", "黑石尖塔", "黑翼之巢", "黑龙军团", "龙骨平原",
               "世界之樹", "亞雷戈斯", "冰霜之刺", "冰風崗哨", "地獄吼", "夜空之歌", "天空之牆", "奧妮克希亞", "寒冰皇冠", "尖石", "屠魔山谷", "巨龍之喉", "巴納札爾", "憤怒使者", "戰歌", "日落沼澤", "暗影之月", "暴風祭壇", "水晶之刺", "狂熱之刃", "眾星之子", "米奈希爾", "聖光之願", "血之谷", "血頂部族", "語風", "諾姆瑞根", "銀翼要塞", "阿薩斯", "雷鱗", "霜之哀傷", "鬼霧峰" ];


