REPORT ZSAMPLE_CUSTOMER_REPORT.

*----------------------------------------------------------------------*
* Titolo: Report Esempio Cliente
* Autore: Repository ABAP
* Data  : 15.04.2025
*
* Descrizione: Questo report mostra un elenco di clienti con le loro
*             informazioni di base utilizzando ALV Grid.
*----------------------------------------------------------------------*

* Dichiarazione tipi e tabelle
TYPES: BEGIN OF ty_customer,
         kunnr TYPE kna1-kunnr,  " Codice cliente
         name1 TYPE kna1-name1,  " Nome cliente
         land1 TYPE kna1-land1,  " Paese
         ort01 TYPE kna1-ort01,  " Città
         stras TYPE kna1-stras,  " Via
       END OF ty_customer.

* Tabelle interne e work area
DATA: it_customers TYPE TABLE OF ty_customer,
      wa_customer  TYPE ty_customer.

* Dichiarazione ALV
DATA: gr_alv      TYPE REF TO cl_salv_table,
      gr_functions TYPE REF TO cl_salv_functions_list.

*----------------------------------------------------------------------*
* Inizio del programma
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM get_data.
  PERFORM display_alv.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data.
  " Seleziona i dati dei clienti dalla tabella KNA1
  SELECT kunnr name1 land1 ort01 stras
    FROM kna1
    INTO TABLE it_customers
    UP TO 100 ROWS.

  IF sy-subrc <> 0.
    MESSAGE 'Nessun dato cliente trovato' TYPE 'I'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv.
  TRY.
    " Creazione oggetto ALV
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = gr_alv
      CHANGING
        t_table      = it_customers ).

    " Impostazione funzioni ALV
    gr_functions = gr_alv->get_functions( ).
    gr_functions->set_all( abap_true ).

    " Ottimizzazione larghezza colonne
    gr_alv->get_columns( )->set_optimize( abap_true ).

    " Visualizzazione ALV
    gr_alv->display( ).

  CATCH cx_salv_msg INTO DATA(lx_error).
    MESSAGE lx_error->get_text( ) TYPE 'E'.
  ENDTRY.
ENDFORM.