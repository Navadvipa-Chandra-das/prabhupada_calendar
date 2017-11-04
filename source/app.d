module main;

import dlangui;
import Prabhupada_сonvert;

// требуется в одном из модулей
mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args) {
  // пути для загрузки ресурсов во время выполнения
  // ресурсы во время компиляции добавляются в исполнимый файл и ищутся они в путях файла dub.json - "stringImportPaths": ["views", "views/res"],
  string[] resourceDirs = [
    appendPath( exePath, "views/" ),
    appendPath( exePath, "../views/res/" ),
  ];

  // установка директорий ресурсов - будут использованы только существующие каталоги
  Platform.instance.resourceDirs = resourceDirs;

  embeddedResourceList.addResources( embedResourcesFromList!( "resources.list" )(  ) );

  // выбираем файл перевода для русского языка
  Platform.instance.uiLanguage = "ru";
  // загружаем тему из файла "theme_default.xml"
  Platform.instance.uiTheme = "theme_default";

  Window window = Platform.instance.createWindow( UIString.fromId( ИМЯ_ПРОГРАММЫ ), null, WindowFlag.Resizable, 670, 450 );

  window.mainWidget = new Класс_Основной_Виджет( "Конвертилка Прабхупада"c );
  window.windowIcon = drawableCache.getImage( "gerb_nizhney_navadvipy_small" );
  window.show();
  // цикл сообщений
  return Platform.instance.enterMessageLoop();
}
