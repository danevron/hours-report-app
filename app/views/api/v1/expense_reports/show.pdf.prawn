Prawn::Document.generate('lior.pdf', document_styles) do |pdf|
  pdf.font_families.update font_family => font_paths
  pdf.font font_family

  pdf.float do
      pdf.text "Expense Report for #{@expense_report.user.name}", title_styles

      pdf.formatted_text [
        {:text => "Start time", :styles => [:bold], :size => font_size},
        {:text => "    "},
        {:text => @expense_report.start_time.strftime("%Y-%m-%d %H:%M"), :size => font_size}
      ]
      pdf.formatted_text [
        {:text => "End time", :styles => [:bold], :size => font_size},
        {:text => "    "},
        {:text => @expense_report.end_time.strftime("%Y-%m-%d %H:%M"), :size => font_size}
      ]
      pdf.formatted_text [
        {:text => "Country", :styles => [:bold], :size => font_size},
        {:text => "    "},
        {:text => @expense_report.country, :size => font_size}
      ]
  end

  pdf.move_down first_table_top_margin

  pdf.move_down 10
  pdf.table(tables_data, row_styles, &table_config)


  pdf.move_cursor_to 40
  pdf.span(content_width) do
    pdf.table(footer_data, footer_styles, &footer_config)
  end
end