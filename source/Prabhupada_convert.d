module Prabhupada_сonvert;

import dlangui;
import std.stdio;
import std.file;
import std.string;
import std.regex;
import std.algorithm;
import dlangui.dialogs.filedlg;
import dlangui.dialogs.dialog;

const string ИМЯ_ПРОГРАММЫ = "ИМЯ_ПРОГРАММЫ"c;

enum Коды_действий : size_t {
  Код_действия_работаем_по_Стахановски = 5500
}

enum Коды_нарядов : size_t {
  Тёмный  = 0,
  Светлый,
  Крупный,
  Патриотичный
}

enum Коды_языков : size_t {
  Русский = 0,
  Английский
}

enum Коды_будь_на_чеку_месяц_начался {
  Всё_спокойно = 0,
  Первый_день_месяца,
  Скоро_первый_день_месяца
}

class Класс_Пожертвование : HorizontalLayout
{
  TextWidget _Текст_Просьба_о_пожертвование;
  TextWidget _Текст_Сайт_Нижней_Навадвипы;
  ImageWidget _Герб_Нижней_Навадвипы;
  
  UrlImageTextButton _Адрес_Нижней_Навадвипы_английскими_буквами;
  UrlImageTextButton _Адрес_Нижней_Навадвипы_русскими_буквами;

  this( string ID )
  {
    super( ID );
    margins( 0 );
    layoutWidth  = FILL_PARENT;
    layoutHeight = FILL_PARENT;
    
    auto вл_Пожертвование = new VerticalLayout();
    вл_Пожертвование.margins( 4 );

    _Текст_Просьба_о_пожертвование = new TextWidget( null, UIString.fromId( "ПРОСЬБА_О_ПОЖЕРТВОВАНИЕ"c ) ).maxLines( 3 );
    // "nizhnyaya-navadvipa.ru"d не будет переводиться на разные языки
    // "nizhnyaya-navadvipa.ru"с напротив - будет переводиться на разные языки, что ни к чему
    _Текст_Сайт_Нижней_Навадвипы   = new TextWidget( null, "nizhnyaya-navadvipa.ru"d );

    _Герб_Нижней_Навадвипы = new ImageWidget( "Герб_Нижней_Навадвипы", "gerb_nizhney_navadvipy");
    
    _Адрес_Нижней_Навадвипы_английскими_буквами = new UrlImageTextButton( null, "nizhnyaya-navadvipa.ru"d, "http://nizhnyaya-navadvipa.ru/"c );
    _Адрес_Нижней_Навадвипы_русскими_буквами    = new UrlImageTextButton( null, "нижняя-навадвипа.рф"d,    "http://нижняя-навадвипа.рф/"c );

    вл_Пожертвование.addChild( _Текст_Просьба_о_пожертвование );
    вл_Пожертвование.addChild( _Адрес_Нижней_Навадвипы_английскими_буквами );
    вл_Пожертвование.addChild( _Адрес_Нижней_Навадвипы_русскими_буквами );

    addChild( _Герб_Нижней_Навадвипы );
    addChild( вл_Пожертвование );
  }
}

class Класс_О_программе : VerticalLayout
{
  this( string ID )
  {
    super( ID );
    margins( 0 );
    
    layoutWidth  = FILL_PARENT;
    layoutHeight = FILL_PARENT;
    
    auto гл_Программа = new HorizontalLayout();
    
    гл_Программа.addChild( new TextWidget( "Программа"c,     UIString.fromId( "Программа"c ) ) );
    гл_Программа.addChild( new TextWidget( "ИМЯ_ПРОГРАММЫ"c, UIString.fromId( "ИМЯ_ПРОГРАММЫ"c ) ).styleId( "POPUP_MENU" ) );
    
    addChild( гл_Программа );

    auto гл_Версия = new HorizontalLayout();

    гл_Версия.addChild( new TextWidget( "Версия"c,     UIString.fromId( "Версия"c ) ) );
    гл_Версия.addChild( new TextWidget( "Номер версии"c, "3.0.2"d ).styleId( "POPUP_MENU" ) );

    addChild( гл_Версия );
  
    auto гл_Автор_программы = new HorizontalLayout();

    гл_Автор_программы.addChild( new TextWidget( "Автор_программы"c, UIString.fromId( "Автор_программы"c ) ) );
    гл_Автор_программы.addChild( new TextWidget( "АВТОР_ПРОГРАММЫ"c, UIString.fromId( "АВТОР_ПРОГРАММЫ"c ) ).styleId( "POPUP_MENU" ) );
    
    addChild( гл_Автор_программы );
    addChild( new UrlImageTextButton( "Почта_автора"c, "navadvipa.chandra.das@nizhnyaya-navadvipa.ru"d, "mailto:navadvipa.chandra.das@nizhnyaya-navadvipa.ru"c ) );

    auto гл_Лицензия = new HorizontalLayout();

    гл_Лицензия.addChild( new TextWidget( "Метка_Лицензия"c, UIString.fromId( "Лицензия"c ) ) );
    гл_Лицензия.addChild( new TextWidget( "Лицензия"c, "boost 1.0"d ).styleId( "POPUP_MENU" ) );

    addChild( гл_Лицензия );
  }
}

class Класс_Конвертилка_переводчик : VerticalLayout
{
  this( string ID )
  {
    super( ID );
    margins( 0 );
    layoutWidth( FILL_PARENT );
    layoutHeight( WRAP_CONTENT );

    auto гл_Язык_программы = new HorizontalLayout();
    гл_Язык_программы.margins( 4 );

    _Текст_Язык_программы             = new TextWidget( null, UIString.fromId( "ЯЗЫК_ПРОГРАММЫ"c ) );
    _Выпадающий_список_Язык_программы = new ComboBox( null );

    _Выпадающий_список_Язык_программы.items = [ "Русский"c, "Английский"c ];

    bool delegate( Widget, int ) Делегат_для_щелчков;
    
    Делегат_для_щелчков = delegate( Widget src, int index )
    {
      Коды_языков Язык = cast( Коды_языков)( index );
      Язык_программы = Язык;
      return true;
    };
    
    _Выпадающий_список_Язык_программы.itemClick = Делегат_для_щелчков;

    _Выпадающий_список_Язык_программы.selectedItemIndex = 0;

    _Текст_Наряд_программы             = new TextWidget( null, UIString.fromId( "Наряд программы"c ) );
    _Выпадающий_список_Наряд_программы = new ComboBox( null );

    _Выпадающий_список_Наряд_программы.items = [ "Тёмный"c, "Светлый"c, "Крупный"c, "Патриотичный"c ];

    Делегат_для_щелчков = delegate( Widget src, int index )
    {
      Коды_нарядов Наряд = cast( Коды_нарядов)( index );
      Наряд_программы = Наряд;
      return true;
    };
    
    _Выпадающий_список_Наряд_программы.itemClick = Делегат_для_щелчков;

    гл_Язык_программы.addChild( _Текст_Язык_программы );
    гл_Язык_программы.addChild( _Выпадающий_список_Язык_программы );
    гл_Язык_программы.addChild( _Текст_Наряд_программы );
    гл_Язык_программы.addChild( _Выпадающий_список_Наряд_программы );

    addChild( гл_Язык_программы );

    _Текст_Входной_файл            = new TextWidget( null, UIString.fromId( "Входной файл"c ) );
    _Текст_Выходной_файл           = new TextWidget( null, UIString.fromId( "Выходной файл"c ) );
    _Текст_Файл_словарь            = new TextWidget( null, UIString.fromId( "Файл словарь"c ) );
    _Текст_Что_делаем              = new TextWidget( null, UIString.fromId( "Что делаем?"c ) );
    _Текст_Работать_по_Стахановски = new TextWidget( null, UIString.fromId( "Работать_по_Стахановски"c ) );

    _Поле_ввода_Входной_файл       = new FileNameEditLine( null );
    _Поле_ввода_Выходной_файл      = new FileNameEditLine( null );
    _Поле_ввода_Файл_словарь       = new FileNameEditLine( null );

    _Поле_ввода_Входной_файл.layoutWidth  = FILL_PARENT;
    _Поле_ввода_Выходной_файл.layoutWidth = FILL_PARENT;
    _Поле_ввода_Файл_словарь.layoutWidth  = FILL_PARENT;
    
    _Поле_ввода_Входной_файл.fileDialogFlags  = DialogFlag.Modal | DialogFlag.Resizable | FileDialogFlag.FileMustExist;
    _Поле_ввода_Выходной_файл.fileDialogFlags = DialogFlag.Modal | DialogFlag.Resizable | FileDialogFlag.FileMustExist;
    _Поле_ввода_Файл_словарь.fileDialogFlags  = DialogFlag.Modal | DialogFlag.Resizable | FileDialogFlag.FileMustExist;

    _Действие_Работаем_по_Стахановски = new Action( Коды_действий.Код_действия_работаем_по_Стахановски, "Есть работать по Стахановски!"c, "dialog-ok-apply", KeyCode.KEY_O, KeyFlag.Control);
    _Кнопка_выполнения                = new ImageTextButton( _Действие_Работаем_по_Стахановски );
    //_Кнопка_выполнения                = new ImageTextButton( "Кнопка выполнения", "dialog-ok-apply"c, "Есть работать по Стахановски!"c );

    _Текст_Где_скачать_GCal = new TextWidget( null, UIString.fromId( "Где_скачать_GCal"c ) );
    _Адрес_GCal = new UrlImageTextButton( null, "krishnadays.com"d,    "krishnadays.com"c );

    auto гл_Входной_файл = new HorizontalLayout();
    гл_Входной_файл.margins( 4 );

    гл_Входной_файл.addChild( _Текст_Входной_файл );
    гл_Входной_файл.addChild( _Поле_ввода_Входной_файл );

    addChild( гл_Входной_файл );

    auto гл_Выходной_файл = new HorizontalLayout();
    гл_Выходной_файл.margins( 4 );

    гл_Выходной_файл.addChild( _Текст_Выходной_файл );
    гл_Выходной_файл.addChild( _Поле_ввода_Выходной_файл );

    addChild( гл_Выходной_файл );

    auto гл_Файл_словарь = new HorizontalLayout();
    гл_Файл_словарь.margins( 4 );

    гл_Файл_словарь.addChild( _Текст_Файл_словарь );
    гл_Файл_словарь.addChild( _Поле_ввода_Файл_словарь );

    addChild( гл_Файл_словарь );

    auto гл_Что_делаем = new HorizontalLayout();

    гл_Что_делаем.addChild( _Текст_Что_делаем );

    auto вл_Что_делаем = new VerticalLayout(); // расположить элементы по вертикали

    _Радио_кнопка_Переводим             = new RadioButton( null, "Переводим"c );
    _Радио_кнопка_Собираем_слова_в_файл = new RadioButton( null, "Собираем слова в файл"c );

    _Радио_кнопка_Переводим.checked = true;

    вл_Что_делаем.addChild( _Радио_кнопка_Переводим             );
    вл_Что_делаем.addChild( _Радио_кнопка_Собираем_слова_в_файл );

    гл_Что_делаем.addChild( вл_Что_делаем );

    auto вл_Как_делаем = new VerticalLayout(); // расположить элементы по вертикали

    _Галочка_кнопка_Пробелы         = new CheckBox( null, "ПРОБЕЛЫ_В_ТАБУЛЯЦИЮ"c );
    _Галочка_кнопка_Пробелы.checked = true;

    вл_Как_делаем.addChild( _Галочка_кнопка_Пробелы );

    _Галочка_кнопка_Удалять_служебные_строки         = new CheckBox( null, "УДАЛЯТЬ_СЛУЖЕБНЫЕ_СТРОКИ"c );
    _Галочка_кнопка_Удалять_служебные_строки.checked = true;

    вл_Как_делаем.addChild( _Галочка_кнопка_Удалять_служебные_строки );

    _Галочка_кнопка_Удалять_пустые_дни         = new CheckBox( null, "УДАЛЯТЬ_ПУСТЫЕ_ДНИ"c );
    _Галочка_кнопка_Удалять_пустые_дни.checked = true;

    вл_Как_делаем.addChild( _Галочка_кнопка_Удалять_пустые_дни );

    _Галочка_кнопка_Удалять_пустые_дни_окончания_поста         = new CheckBox( null, "УДАЛЯТЬ_ПУСТЫЕ_ДНИ_ОКОНЧАНИЯ_ПОСТА"c );
    _Галочка_кнопка_Удалять_пустые_дни_окончания_поста.checked = true;

    вл_Как_делаем.addChild( _Галочка_кнопка_Удалять_пустые_дни_окончания_поста );

    _Галочка_кнопка_Удалять_комментарий_Экадаши = new CheckBox( null, "УДАЛЯТЬ_КОММЕНТАРИЙ_ЭКАДАШИ"c );
    _Галочка_кнопка_Удалять_комментарий_Экадаши.checked = true;

    вл_Как_делаем.addChild( _Галочка_кнопка_Удалять_комментарий_Экадаши );

    _Галочка_кнопка_Сохранять_первый_день_месяца = new CheckBox( null, "СОХРАНЯТЬ_ПЕРВЫЙ_ДЕНЬ_МЕСЯЦА"c );
    _Галочка_кнопка_Сохранять_первый_день_месяца.checked = true;

    вл_Как_делаем.addChild( _Галочка_кнопка_Сохранять_первый_день_месяца );

    гл_Что_делаем.addChild( вл_Как_делаем );

    addChild( гл_Что_делаем );

    auto гл_Работать_по_Стахановски = new HorizontalLayout();

    гл_Работать_по_Стахановски.addChild( _Текст_Работать_по_Стахановски );
    гл_Работать_по_Стахановски.addChild( _Кнопка_выполнения );
    
    // можно и без onAction, но через Action интереснее!
    //_Кнопка_выполнения.click = &Работаем_по_Стахановски;
    
    addChild( гл_Работать_по_Стахановски );

    auto гл_Где_скачать_GCal = new HorizontalLayout();

    гл_Где_скачать_GCal.addChild( _Текст_Где_скачать_GCal );
    гл_Где_скачать_GCal.addChild( _Адрес_GCal );

    addChild( гл_Где_скачать_GCal );
  }
  
  @property Язык_программы( Коды_языков Язык ) {
    final switch ( Язык ) {
    case Коды_языков.Русский :
      Log.d( "Переключаемся на русский" );
      Platform.instance.uiLanguage = "ru";
      break;
    case Коды_языков.Английский :
      Log.d( "Переключаемся на английский" );
      Platform.instance.uiLanguage = "en";
      break;
    }
    window.windowCaption = UIString.fromId( ИМЯ_ПРОГРАММЫ );
  }

  @property Наряд_программы( Коды_нарядов Наряд )
  {
    auto p = parent;
    // если case будут идти не по порядку как в enum Коды_нарядов, то программа вообще не запустится!
    final switch ( Наряд ) {
    case Коды_нарядов.Тёмный :
      Log.d( "Одеваемся в тёмный наряд" );
      Platform.instance.uiTheme = "theme_dark";
      if ( p ) p.backgroundImageId = "tx_fabric_dark.tiled";
      break;
    case Коды_нарядов.Светлый :
      Log.d( "Одеваемся в светлый наряд" );
      Platform.instance.uiTheme = "theme_default";
      if ( p ) p.backgroundImageId = "tx_fabric.tiled";
      break;
    case Коды_нарядов.Крупный :
      Log.d( "Одеваемся в весёлый наряд" );
      Platform.instance.uiTheme = "theme_large";
      if ( p ) p.backgroundImageId = "tx_fabric_large.tiled";
      break;
    case Коды_нарядов.Патриотичный :
      Log.d( "Одеваемся в патриотический наряд" );
      Platform.instance.uiTheme = "theme_large";
      if ( p ) p.backgroundImageId = "gerb_nizhney_navadvipy_jpg.tiled";
      break;
    }
  }

  TextWidget  _Текст_Язык_программы;
  ComboBox    _Выпадающий_список_Язык_программы;

  TextWidget  _Текст_Наряд_программы;
  ComboBox    _Выпадающий_список_Наряд_программы;

  TextWidget _Текст_Входной_файл;
  TextWidget _Текст_Выходной_файл;
  TextWidget _Текст_Файл_словарь;
  TextWidget _Текст_Что_делаем;
  TextWidget _Текст_Работать_по_Стахановски;

  TextWidget _Текст_Где_скачать_GCal;
  UrlImageTextButton _Адрес_GCal;

  FileNameEditLine _Поле_ввода_Входной_файл;
  FileNameEditLine _Поле_ввода_Выходной_файл;
  FileNameEditLine _Поле_ввода_Файл_словарь;

  RadioButton _Радио_кнопка_Переводим;
  RadioButton _Радио_кнопка_Собираем_слова_в_файл;
  
  CheckBox _Галочка_кнопка_Пробелы;
  CheckBox _Галочка_кнопка_Удалять_служебные_строки;
  CheckBox _Галочка_кнопка_Удалять_пустые_дни;
  CheckBox _Галочка_кнопка_Удалять_пустые_дни_окончания_поста;
  CheckBox _Галочка_кнопка_Удалять_комментарий_Экадаши;
  CheckBox _Галочка_кнопка_Сохранять_первый_день_месяца;

  Action _Действие_Работаем_по_Стахановски;
  ImageTextButton _Кнопка_выполнения;
  
  // используется, чтобы не обрабатывать повторно один и тот же файл словаря
  dstring _Ключ_словаря;
  string[ string ] _Словарь_слов;
  string[ string ] _Словарь_фраз;

  bool Работаем_по_Стахановски( Widget w )
  {
    if ( _Радио_кнопка_Переводим.checked ) {
      Переводим();
    } else if ( _Радио_кнопка_Собираем_слова_в_файл.checked ) {
      Собираем_слова_в_файл();
    }
    return true;
  }

  bool Logo( string s )
  {
    Log.d( s );
    return true;
  }

  void Заполняем_словарь()
  {
    if ( _Ключ_словаря != _Поле_ввода_Файл_словарь.text ) {
      auto Файл_словарь = File( _Поле_ввода_Файл_словарь.text, "r" );
      scope( exit ) Файл_словарь.close();

      _Словарь_слов.clear();
      _Словарь_фраз.clear();

      string строка, слово;
      auto шаблон_строки_словаря = ctRegex!r"(.+) = (.+)";
      while ( ( строка = Файл_словарь.readln() ) !is null ) {
        auto слова = std.regex.matchFirst( строка, шаблон_строки_словаря );
        
        if ( слова.captures.length != 3 ) continue;

        слово = слова.captures[ 2 ];
        if ( слово == " " ) слово = "";
        
        if ( indexOf( слова.captures[ 1 ], ' ' ) == -1 )
          _Словарь_слов[ слова.captures[ 1 ] ] = слово;
        else
          _Словарь_фраз[ слова.captures[ 1 ] ] = слово;
      }
      _Ключ_словаря = _Поле_ввода_Файл_словарь.text;
    }
    assert( Logo( "Словарь слов заполнен! " ) );
    Log.d( _Словарь_слов );
    assert( Logo( "Словарь фраз заполнен! " ) );
    Log.d( _Словарь_фраз );
  }


  void Переводим()
  {
    if ( _Поле_ввода_Входной_файл.text.empty ) {
      window.showMessageBox( UIString.fromId( "ЧЕСТЬ_ИМЕЮ_ДОЛОЖИТЬ"c ),
                             UIString.fromId( "Входной_файл_не_выбран"c ) );
      return;
    }
    if ( _Поле_ввода_Выходной_файл.text.empty ) {
      window.showMessageBox( UIString.fromId( "ЧЕСТЬ_ИМЕЮ_ДОЛОЖИТЬ"c ),
                             UIString.fromId( "Выходной_файл_не_выбран"c ) );
      return;
    }
    if ( _Поле_ввода_Файл_словарь.text.empty ) {
      window.showMessageBox( UIString.fromId( "ЧЕСТЬ_ИМЕЮ_ДОЛОЖИТЬ"c ),
                             UIString.fromId( "Файл_словарь_не_выбран"c ) );
      return;
    }
    auto Входной_файл = File( _Поле_ввода_Входной_файл.text, "r" );
    scope( exit ) Входной_файл.close();
    auto Выходной_файл = File( _Поле_ввода_Выходной_файл.text, "w" );
    scope( exit ) Выходной_файл.close();

    Заполняем_словарь();

    auto выражение_разделитель                      = ctRegex!r"[ \t,.;:\r\n\[\]()*+?{}]+";
    auto выражение_цепочка_пробелов_в_начале_строки = ctRegex!r"^[ ]{2,}";                    // два и более пробела в начале строки
    // Захват строки: "16 Jun 2022 Th   Dvitiya                           K Brahma    Purva-asadha"
    // или такой: "24 Jul 2022 Su   Ekadasi (suitable for fasting)    K Vriddhi   Rohini          *"
    // кавычки поставлены для наглядности, в исходном файле их нет
    // регулярные выражения удобно проверять в текстовом редакторе Kate, в котором я и пишу программу
    // он очень удобный, есть вертикальные блоки даже. Регулярные выражения можно включить в расширенном режиме поиска и замены
    // префикс r перед кавычками в языке D означает "сырую строку" - что видишь, то и есть, а иначе было бы много сдвоенных \
    // великолепное удобство для регулярных выражений!
    auto выражение_день = ctRegex!r"^\s?([\d]{1,2})\s(\w{3,})\s([\d]{1,5})\s(\w{2,})(\s+)([\w\s()]+)(K|G)\s([\w-]+)(\s+)([\w-]+)([\s]*[*]?)";
    // выражения для служебных строк
    // на всякий случай поставил проверку на знак минус в широте и долготе
    // и дал возможность находить разное количество значащих цифр в градусах широты и долготы 
    auto выражение_служебная_строка               = ctRegex!r"((^-{70,})|(^\s?DATE)|((-)?(\d)?\d\w\d\d\s(-)?(\d)?(\d)?\d\w\d\d))";
    auto выражение_окончание_поста                = ctRegex!r"Break\sfast\s";
    // подготавливаем для удаления строки из тире и GCal
    auto выражение_для_чистки_Месяца              = ctRegex!r"\s+GCal\s\d\d";
    auto выражение_для_чистки_Солнца              = ctRegex!r" ?-{3,} ?";
    auto выражение_месяц_ли_это                   = ctRegex!r"\,\sGaurabda\s";
    auto выражение_для_чистки_комментария_Экадаши = ctRegex!r"\s\((not)?\s?suitable for fasting\)";

    // Чудо чудесное
    string Чудо_слов( Captures!(string) m )
    {
        return _Словарь_слов.get( m.hit, m.hit );
    }
    
    Log.i( "Приступим, помолясь." );
    
    // Все переменные выносим за тело цикла для оптимизации
    string строка;
    
    bool Нужна_ли_табуляция                          = _Галочка_кнопка_Пробелы.checked;
    bool Нужно_ли_удалять_служебные_строки           = _Галочка_кнопка_Удалять_служебные_строки.checked;
    bool Нужно_ли_удалять_пустые_дни                 = _Галочка_кнопка_Удалять_пустые_дни.checked;
    bool Нужно_ли_удалять_пустые_дни_окончания_поста = _Галочка_кнопка_Удалять_пустые_дни_окончания_поста.checked;
    bool Нужно_ли_удалять_комментарий_Экадаши        = _Галочка_кнопка_Удалять_комментарий_Экадаши.checked;
    bool Нужно_ли_сохранять_первый_день_месяца       = _Галочка_кнопка_Сохранять_первый_день_месяца.checked;

    auto фразы = _Словарь_фраз.keys;
    фразы.sort!( "a.length > b.length" );
    
    Captures!string служебная_строка, день_месяца, проверка_месяца, пробелы_в_начале_строки, окончание_поста;
    string[] слова;
    
    bool день_ли_это;
    Тип_строки вид_строки;
    
    Класс_Хитрый_накопитель Хитрый_накопитель = new Класс_Хитрый_накопитель( !Нужно_ли_удалять_пустые_дни, !Нужно_ли_удалять_пустые_дни_окончания_поста, Нужно_ли_сохранять_первый_день_месяца, Выходной_файл );
    // цикл не простой, а с меткой "цикл"
    цикл: while ( ( строка = Входной_файл.readln() ) !is null ) {

      if ( Нужно_ли_удалять_служебные_строки ) {
        if ( строка.length < 3 )
          // чудо, а не возможность! Можно делать любые переходы и вылеты из множества вложенных циклов!
          continue цикл;
        служебная_строка = matchFirst( строка, выражение_служебная_строка );
        if ( служебная_строка.captures.length > 0 )
          continue цикл;
      }
    
      день_месяца = matchFirst( строка, выражение_день );
      день_ли_это = день_месяца.captures.length > 0;
      
      if ( день_ли_это ) {
        вид_строки = Тип_строки.День;
        if ( Нужна_ли_табуляция ) {
          строка = "\t"c ~ день_месяца.captures[ 1 ] ~ "\t"c ~ день_месяца.captures[ 2 ]              ~ "\t"c ~ день_месяца.captures[ 3 ] ~
                   "\t"c ~ день_месяца.captures[ 4 ] ~ "\t"c ~ день_месяца.captures[ 6 ].stripRight() ~ "\t"c ~ день_месяца.captures[ 7 ] ~
                   "\t"c ~ день_месяца.captures[ 8 ] ~ "\t"c ~ день_месяца.captures[ 10 ];
          // обрабатываем "звездочку" поста
          if ( день_месяца.captures[ 11 ].indexOf( '*' ) != -1 )
            строка ~= "\t*"c;
          строка ~= "\n";
        }
        // Удаляем, при желании комментрий к Экадаши - подходит для поста и не додходит для поста. Все равно есть еще символ звездочка и
        // строка с именем Экадаши и явным упоминанием о посте!
        if ( Нужно_ли_удалять_комментарий_Экадаши ) {
          строка = replaceFirst( строка, выражение_для_чистки_комментария_Экадаши, ""c );
        }
      } else {
        проверка_месяца = matchFirst( строка, выражение_месяц_ли_это );
        if ( проверка_месяца.captures.length > 0 ) {
          вид_строки = Тип_строки.Месяц;
          // Просто удаляем цепочку начальных пробелов в строках месяца, если готовим табуляцию
          if ( Нужна_ли_табуляция )
            строка = replaceFirst( строка, выражение_цепочка_пробелов_в_начале_строки, ""c );
        } else {
          // Заменяем цепочку пробелов вначале строки на один единственный символ табуляции для праздников, но только если нужна табуляция
          пробелы_в_начале_строки = matchFirst( строка, выражение_цепочка_пробелов_в_начале_строки );
          if ( пробелы_в_начале_строки.captures.length > 0 ) {
            окончание_поста = matchFirst( строка, выражение_окончание_поста );
            if ( окончание_поста.captures.length > 0 )
              вид_строки = Тип_строки.Окончание_поста;
            else
              вид_строки = Тип_строки.Праздник;
            if ( Нужна_ли_табуляция )
              строка = replaceFirst( строка, выражение_цепочка_пробелов_в_начале_строки, "\t"c );
          } else
            вид_строки = Тип_строки.Солнце;
        }
      }

      // Удаляем строки из тире и GCal, но только если нужна табуляци. В книге они не нужны.
      // Можно указать номер версии программы GCal в колонтитулах книги при желании
      if ( Нужна_ли_табуляция ) {
        if ( вид_строки == Тип_строки.Месяц )
          строка = replaceAll( строка, выражение_для_чистки_Месяца, ""c );
        if ( вид_строки == Тип_строки.Солнце )
          строка = replaceAll( строка, выражение_для_чистки_Солнца, ""c );
      }
      
      // Переводим сначала фразы. Длительная операция, так как переводятся все имеющиеся фразы, не зависимо от того, встречаются ли они в строке или нет
      foreach ( ref фраза; фразы )
        строка = replaceAll( строка, regex( фраза ), _Словарь_фраз[ фраза ] );

      // Переводим слова. Быстрее, так как переводятся только те слова, которые встречаются в данной конкретной строке
      слова = std.regex.split( строка, выражение_разделитель );
      // сортируем, чтобы короткие слова не позаменялись в более длинных словах внутри
      // Вдохнули поглубже! Такого чуда я еще не видел! Не иначе как mixin в действии!
      слова.sort!( "a.length > b.length" );
      foreach ( ref слово; слова )
        if ( слово.length > 0 )
          строка = replaceAll!( Чудо_слов )( строка, regex( слово ) );
      
      Хитрый_накопитель.В_копилку( строка, вид_строки );
    }
    // Пропихнем в файл последнюю строку
    Хитрый_накопитель.В_копилку( ""c, Тип_строки.День );

    window.showMessageBox( UIString.fromId( "ЧЕСТЬ_ИМЕЮ_ДОЛОЖИТЬ"c ),
                           UIString.fromId( "ЗАДАНИЕ_ВЫПОЛНЕНО!"c ) );
  }

  void Собираем_слова_в_файл()
  {
    if ( _Поле_ввода_Входной_файл.text.empty ) {
      window.showMessageBox( UIString.fromId( "ЧЕСТЬ_ИМЕЮ_ДОЛОЖИТЬ"c ),
                             UIString.fromId( "Входной_файл_не_выбран"c ) );
      return;
    }
    if ( _Поле_ввода_Выходной_файл.text.empty ) {
      window.showMessageBox( UIString.fromId( "ЧЕСТЬ_ИМЕЮ_ДОЛОЖИТЬ"c ),
                             UIString.fromId( "Выходной_файл_не_выбран"c ) );
      return;
    }
    auto Входной_файл = File( _Поле_ввода_Входной_файл.text, "r" );
    scope( exit ) Входной_файл.close();
    auto Выходной_файл = File( _Поле_ввода_Выходной_файл.text, "w" );
    scope( exit ) Выходной_файл.close();

    string[] результат;
    string строка;
    auto разделитель = ctRegex!r"[ \t,.;:\r\n]+";

    while ( ( строка = Входной_файл.readln() ) !is null ) {
      auto слова = std.regex.split( строка, разделитель );
      foreach ( ref слово; слова )
        if ( (слово.length > 0 ) && !canFind( результат, слово ) )
          результат ~= слово;
    }

    foreach ( ref слово; результат )
      Выходной_файл.writeln( слово );

    window.showMessageBox( UIString.fromId( "ЧЕСТЬ_ИМЕЮ_ДОЛОЖИТЬ"c ),
                           UIString.fromId( "СЛОВАРЬ_ЗАПОЛНЕН!"c ) );
  }

}

enum Тип_строки {
  День = 0,
  Солнце,
  Месяц,
  Праздник,
  Окончание_поста
}

class Класс_Хитрый_накопитель {

  string _Копилка;
  size_t _счетчик_строк = 0;
  bool _печатать_пустые_дни;
  bool _печатать_пустые_дни_окончания_поста;
  File _Выходной_файл;
  Тип_строки _Тип_последней_строки = Тип_строки.Солнце;
  bool _есть_ли_в_копилке_окончание_поста = false;
  Коды_будь_на_чеку_месяц_начался _будь_на_чеку_месяц_начался = Коды_будь_на_чеку_месяц_начался.Всё_спокойно;
  size_t _длина_первой_строки = 0;
  bool _сохранять_первый_день_месяца;
  
  void Запомнить_длину_первой_строки()
  {
    if ( _счетчик_строк == 1 )
      _длина_первой_строки = _Копилка.length;
  }
  
  this( bool печатать_пустые_дни, bool печатать_пустые_дни_окончания_поста
      , bool сохранять_первый_день_месяца, File Выходной_файл ) {
    _печатать_пустые_дни                 = печатать_пустые_дни;
    _печатать_пустые_дни_окончания_поста = печатать_пустые_дни_окончания_поста;
    _сохранять_первый_день_месяца        = сохранять_первый_день_месяца;
    _Выходной_файл = Выходной_файл;
  }
  
  void Опорожнение_копилки( string строка, Тип_строки вид_строки )
  {
    bool сохранять_ли_в_файле = false;
    switch ( _счетчик_строк ) {
    case 1 :
      if ( _Тип_последней_строки == Тип_строки.День ) {
        if ( _сохранять_первый_день_месяца ) {
          сохранять_ли_в_файле = _будь_на_чеку_месяц_начался == Коды_будь_на_чеку_месяц_начался.Первый_день_месяца;
          if ( сохранять_ли_в_файле )
            _будь_на_чеку_месяц_начался = Коды_будь_на_чеку_месяц_начался.Всё_спокойно;
          else if ( _будь_на_чеку_месяц_начался == Коды_будь_на_чеку_месяц_начался.Скоро_первый_день_месяца )
            _будь_на_чеку_месяц_начался = Коды_будь_на_чеку_месяц_начался.Первый_день_месяца;
        } else
          сохранять_ли_в_файле = _печатать_пустые_дни;
      } else
        сохранять_ли_в_файле = true;
        
      break;
    case 2 :
      if ( _есть_ли_в_копилке_окончание_поста && !_печатать_пустые_дни_окончания_поста )
        // Удаляем пустой день окончания поста, так как счетчик строк равен 2, то больше праздников нет
        _Копилка = _Копилка[ _длина_первой_строки .. $ ];
      сохранять_ли_в_файле = true;
      break;
    default :
      сохранять_ли_в_файле = true;
      break;
    }

    _есть_ли_в_копилке_окончание_поста = false;

    if ( сохранять_ли_в_файле )
      _Выходной_файл.write( _Копилка );
    
    _Копилка = строка;
    _счетчик_строк = 1;
    Запомнить_длину_первой_строки();
    _Тип_последней_строки = вид_строки;
  }
  
  void В_копилку( string строка, Тип_строки вид_строки )
  {
    if ( _печатать_пустые_дни ) {
      // Выводим строку и не морочим себе голову
      _Выходной_файл.write( строка );
    } else {
      if ( вид_строки == Тип_строки.Месяц )
        _будь_на_чеку_месяц_начался = _Тип_последней_строки == Тип_строки.День ? Коды_будь_на_чеку_месяц_начался.Скоро_первый_день_месяца : Коды_будь_на_чеку_месяц_начался.Первый_день_месяца;
      else if ( вид_строки == Тип_строки.Праздник )
        // если попался праздник, то нет нужды сохранять следующий за ним пустой день месяца
        _будь_на_чеку_месяц_начался = Коды_будь_на_чеку_месяц_начался.Всё_спокойно;

      if ( !( вид_строки == Тип_строки.Праздник || вид_строки == Тип_строки.Окончание_поста ) )
        Опорожнение_копилки( строка, вид_строки );
      else {
        _Копилка ~= строка;
        ++_счетчик_строк;
        if ( вид_строки == Тип_строки.Окончание_поста )
         _есть_ли_в_копилке_окончание_поста = true;
        _Тип_последней_строки = вид_строки;
        Запомнить_длину_первой_строки();
      }
    }
  }
}


class Класс_Основной_Виджет : FrameLayout
{
  TabWidget _Закладки;
  Класс_Конвертилка_переводчик _Конвертилка_переводчик;
  Класс_Пожертвование _Пожертвование;
  Класс_О_программе _О_программе;
  
  this( string ID ) {
    super( ID );
    //_cupPage = new CupPage();
    
    _Конвертилка_переводчик = new Класс_Конвертилка_переводчик( "ТаблицаКонвертилка"c );
    
    _Пожертвование      = new Класс_Пожертвование( "Пожертвование"c );
    _О_программе        = new Класс_О_программе( "О_программе"c );
    
    _Закладки = new TabWidget( "Закладки"c );
    
    _Закладки.layoutWidth = FILL_PARENT;
    _Закладки.layoutHeight = FILL_PARENT;
    
    _Закладки.addTab( _Конвертилка_переводчик, "ЗАКЛАДКА_КОНВЕРТИЛКА_ПЕРЕВОДЧИК"c );
    _Закладки.addTab( _Пожертвование, "ЗАКЛАДКА_ПОЖЕРТВОВАНИЕ"c );
    _Закладки.addTab( _О_программе, "ЗАКЛАДКА_О_ПРОГРАММЕ"c );

    _Закладки.tabHost.padding = Rect( 10.pointsToPixels, 10.pointsToPixels, 10.pointsToPixels, 10.pointsToPixels );

    addChild( _Закладки );
    
    _Конвертилка_переводчик._Выпадающий_список_Наряд_программы.selectedItemIndex = 1;
    
    onAction = delegate( Widget source, const Action a )
    {
      switch ( a.id ) {
      case Коды_действий.Код_действия_работаем_по_Стахановски :
        return _Конвертилка_переводчик.Работаем_по_Стахановски( null );
      case StandardAction.OpenUrl :
        platform.openURL( a.stringParam );
        return true;
      default :
        return false;
      }
    };
    // Сохраняем для примера. 
    // showChild(_cupPage.id, Visibility.Invisible, true);
    // backgroundImageId = "tx_fabric.tiled";
  }
}
