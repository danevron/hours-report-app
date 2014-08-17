module ExpenseReportsHelper
  module PDFLayout
    @@styles = {
      :document_styles        => {:page_size => 'A4', :margin => [28, 35, 25, 34]},
      :content_width          => 525,
      :title_left_margin      => 220,
      :font_size              => 9,
      :title_size             => 12,
      :first_table_top_margin => 96,
      :table_title_size       => 21,
      :table_subtitle_size    => 16,
      :character_spacing      => 1,
      :logo_size              => 59.5,

      :row_styles => {
        :header => true,
        :width => 525,
        :row_colors => ['ffffff'],
        :cell_style => {
          :padding => [4, 0],
          :border_width => 0,
          :font_style => :normal,
          :size => 9
        }
      },

      :footer_styles => {
        :header => true,
        :width => 525,
        :row_colors => ['ffffff'],
        :cell_style => {
          :padding => [0, 0],
          :border_width => 0,
          :font_style => :normal,
          :size => 7
        }
      }
    }

    def table_config
      ->(table)do
        table.column(-2..-1).align = :right

        table.row(0).tap do |header|
          header.font_style = :bold
          header.border_width = [0.1, 0]
        end

        table.row(-1).tap do |total|
          total.font_style = :bold
          total.border_width = [0.7, 0, 0.5, 0]
          total.border_lines = [:solid, :solid, :dotted, :solid]
        end
      end
    end

    def method_missing(method)
      @@styles[method]
    end
  end

  class ExpenseReportPDF

    def self.build(expense_report)
      new(expense_report).generate_pdf
    end

    def initialize(expense_report)
      @expense_report = expense_report
    end

    def generate_pdf
      Prawn::Document.new(document_styles) do |pdf|
        pdf.font_families.update font_family => font_paths
        pdf.font font_family
        expense_report_details(pdf)
        expenses_table(pdf)
        signatures(pdf)
      end
    end

    private

    def expense_report_details(pdf)
      pdf.float do
        pdf.formatted_text [
          {:text => "Travel expense report for #{@expense_report.user.name}", :styles => [:bold], :size => title_size}
        ]

        pdf.move_down 10

        pdf.formatted_text [
          {:text => "Boarding time", :styles => [:bold], :size => font_size},
          {:text => "    "},
          {:text => @expense_report.start_time.strftime("%Y-%m-%d %H:%M"), :size => font_size}
        ]
        pdf.formatted_text [
          {:text => "Landing time", :styles => [:bold], :size => font_size},
          {:text => "     "},
          {:text => @expense_report.end_time.strftime("%Y-%m-%d %H:%M"), :size => font_size}
        ]
        pdf.formatted_text [
          {:text => "Country", :styles => [:bold], :size => font_size},
          {:text => "           "},
          {:text => @expense_report.country, :size => font_size}
        ]
      end
    end

    def expenses_table(pdf)
      pdf.move_down first_table_top_margin
      pdf.move_down 10
      pdf.table(table_data, row_styles, &table_config)
    end

    def signatures(pdf)
      pdf.move_down 30
      pdf.span(content_width) do
        pdf.formatted_text [
          {:text => "Employee Signature:", :styles => [:bold], :size => font_size},
          {:text => "    "},
          {:text => "______________", :size => font_size},
          {:text => "           "},
          {:text => "Manager Signature:", :styles => [:bold], :size => font_size},
          {:text => "    "},
          {:text => "______________", :size => font_size}
        ]
      end
    end

    def table_data
      PDFTable.new(@expense_report.expenses, @expense_report.total).to_a
    end

    include PDFLayout
  end

  class PDFTable
    include ActionView::Helpers

    def initialize(expenses, total)
      @expenses = expenses
      @total = total
    end

    def to_a
      [header_row] +
      @expenses.map{|expense| row_data(expense) }.flatten(1) <<
      footer_row('Total (ILS)', @total)
    end

    private

    def header_row
      ['Description', 'Amount', 'Quantity', 'Currency', 'Exchange rate', 'Total (ILS)']
    end

    def row_data(expense)
      row_data = [
        expense.description,
        expense.amount.to_f,
        expense.quantity.to_f,
        expense.currency,
        expense.exchange_rate.to_f,
        expense.total
      ]

      [row_data]
    end

    def footer_row(label, amount)
      [
        {:align => :right, :colspan => 6, :content => label}, amount
      ]
    end
  end
end
