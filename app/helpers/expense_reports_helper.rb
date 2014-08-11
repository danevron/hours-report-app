module ExpenseReportsHelper
  def tables_data
    @tables_data ||= PDFTable.new(@expense_report.expenses, @expense_report.total).to_a
  end

  def footer_data
    footer_data = [ ['signature', "_________________" ] ]
  end

  class PDFTable
    include ActionView::Helpers

    def initialize(expenses, total)
      @expenses = expenses
      @total = total
    end

    def to_a
      [self.class.header] +
      @expenses.map{|expense| row_data(expense) }.flatten(1) <<
      footer_row('Total', @total)
    end

    private

    def self.header
      ['description', 'amount', 'quantity', 'currency', 'exchange rate', 'total']
    end

    def row_data(expense)
      row_data = [
        expense.description,
        expense.amount.to_f,
        expense.quantity.to_i,
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

  module PDFLayout

    @@styles = {
      :document_styles        => {:page_size => 'A4', :margin => [28, 35, 25, 34]},
      :content_width          => 525,
      :title_left_margin      => 220,
      :font_size              => 9,
      :first_table_top_margin => 96,
      :table_title_size       => 21,
      :table_subtitle_size    => 16,
      :character_spacing      => 1,
      :logo_size              => 59.5,
      :title_styles           => {:size => 29},

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
          header.border_width = [0.7, 0]
        end

        table.row(-3).tap do |subtotal|
          subtotal.border_width = [0.1, 0, 0, 0]
        end

        table.row(-1).tap do |total|
          total.font_style = :bold
          total.border_width = [0.7, 0, 0.5, 0]
          total.border_lines = [:solid, :solid, :dotted, :solid]
        end
      end
    end

    def footer_config
      ->(table)do
        table.row(0).tap do |header|
          header.font_style = :bold
          header.border_width = [0.7, 0, 0, 0]
        end
      end
    end

    def method_missing(method)
      @@styles[method]
    end

    def pdf_logo_path(tenant)
      "#{Rails.root.to_s}/app/assets/images/tenants/#{tenant.subdomain}/logo-blue.png"
    end
  end

  include PDFLayout
end
