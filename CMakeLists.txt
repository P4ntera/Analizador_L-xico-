cmake_minimum_required(VERSION 3.16)

project(AnalizadorLexico VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Decirle a AUTOUIC dónde están los archivos .ui
set(CMAKE_AUTOUIC_SEARCH_PATHS ${CMAKE_CURRENT_SOURCE_DIR})

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets)

# Ruta a win_flex.exe
set(FLEX_EXECUTABLE "C:/Users/eugen/Downloads/win_flex_bison-2.5.25/win_flex.exe")

# Generar lex.yy.c desde lexer.l
add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/lex.yy.c"
    COMMAND "${FLEX_EXECUTABLE}"
            --wincompat
            -o "${CMAKE_CURRENT_SOURCE_DIR}/lex.yy.c"
            "${CMAKE_CURRENT_SOURCE_DIR}/lexer.l"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/lexer.l"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT "Generando lex.yy.c con FLEX..."
    VERBATIM
)

set_source_files_properties(
    "${CMAKE_CURRENT_SOURCE_DIR}/lex.yy.c"
    PROPERTIES GENERATED TRUE
)

set(PROJECT_SOURCES

    main.cpp
    mainwindow.cpp
    mainwindow.h
    mainwindow.ui

    lexer.l
    parser.y

    lex.yy.c
    parser.tab.c
    parser.tab.h

)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(AnalizadorLexico
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
        parser.tab.c parser.tab.h parser.y
    )
else()
    add_executable(AnalizadorLexico ${PROJECT_SOURCES})
endif()

target_link_libraries(AnalizadorLexico PRIVATE
    Qt${QT_VERSION_MAJOR}::Widgets
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(AnalizadorLexico)
endif()