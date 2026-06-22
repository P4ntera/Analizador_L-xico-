#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QMessageBox>
#include <QStandardPaths>
#include <cstdio>
#include <cstring>

/* ── Declaraciones de FLEX ── */
extern "C" {

extern FILE *yyin;
extern FILE *salida;

extern int yyparse();
extern int token_id;

extern int sintacticoCorrecto;
extern int semanticoCorrecto;
extern int totalSimbolos;
extern char ultimoErrorSemantico[200];

void limpiarTabla();

}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    setWindowTitle("Analizador Léxico — Lenguaje C");

    tempDir = QStandardPaths::writableLocation(
        QStandardPaths::TempLocation);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_btnAnalizar_clicked()
{
    QString codigo = ui->txtEntrada->toPlainText().trimmed();
    if (codigo.isEmpty()) {
        QMessageBox::warning(this, "Aviso",
                             "Escribe o pega código C antes de analizar.");
        return;
    }

    /* 1. Rutas de archivos temporales */
    QString pathEntrada = tempDir + "/entrada_lexico.c";
    QString pathSalida  = tempDir + "/salida_lexico.txt";

    /* 2. Escribir código en entrada.txt */
    {
        QFile f(pathEntrada);
        if (!f.open(QIODevice::WriteOnly | QIODevice::Text)) {
            QMessageBox::critical(this, "Error",
                                  "No se pudo crear el archivo temporal de entrada.");
            return;
        }
        QTextStream out(&f);
        out << codigo;
    }

    /* 3. Abrir archivos para FLEX */
    yyin   = fopen(pathEntrada.toStdString().c_str(), "r");
    salida = fopen(pathSalida.toStdString().c_str(),  "w");

    if (!yyin || !salida) {
        QMessageBox::critical(this, "Error",
                              "No se pudieron abrir los archivos para FLEX.");
        if (yyin)   fclose(yyin);
        if (salida) fclose(salida);
        return;
    }

    /* 4. Encabezado de la tabla */
    token_id = 1;
    fprintf(salida, "%-6s %-12s %-22s %s\n",
            "ID", "AMBITO", "TIPO", "VALOR");
    fprintf(salida, "%s\n",
            "------------------------------------------------------");

    sintacticoCorrecto = 1;
    semanticoCorrecto = 1;

    limpiarTabla();

    strcpy(ultimoErrorSemantico, "");

    yyparse();

    yyparse();

    if(semanticoCorrecto)
    {
        ui->lblSemantico->setText("✓ Semántica correcta");
    }
    else
    {
        ui->lblSemantico->setText(
            QString::fromUtf8(ultimoErrorSemantico)
            );
    }
    fclose(yyin);
    fclose(salida);

    if (sintacticoCorrecto)
    {
        ui->txtSintaxis->setText("✓ Sintaxis correcta");
    }
    else
    {
        ui->txtSintaxis->setText("✗ Error sintáctico");
    }

    QFile res(pathSalida);
    if (!res.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QMessageBox::critical(this, "Error",
                              "No se pudo leer el archivo de resultados.");
        return;
    }
    QTextStream in(&res);
    ui->txtResultado->setPlainText(in.readAll());
}

void MainWindow::on_btnLimpiar_clicked()
{
    ui->txtEntrada->clear();
    ui->txtResultado->clear();
    ui->txtSintaxis->clear();
    ui->lblSemantico->clear();
}

void MainWindow::on_btnSalir_clicked()
{
    close();
}