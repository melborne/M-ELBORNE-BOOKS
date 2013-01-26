# encoding: UTF-8

# Gumraod Sales CSV Statistic Library
# by melborne
#
# Usage: ruby gumroad_sales.rb [key]
# key: title, date, or buyer

require "csv"
class String
  def ~
    margin = scan(/^ +/).map(&:size).min
    gsub(/^ {#{margin}}/, '')
  end
end

class CSV::Table
  def group_by(&blk)
    Hash[ super.map { |k, v| [k, CSV::Table.new(v)]  }]
  end
end

class Sales
  def initialize(csv, target=[:price_, :net_revenue_])
    @table = CSV.table(csv)
    @target_fields = target
    @stat = nil
  end

  def headers
    @table.headers
  end

  def totals
    fields = @target_fields.map { |f| @table[f].inject(:+) }
    [@table.size, *fields]
  end

  def stat_by(key)
    @stat =
      @table.group_by { |t| t[key] }
            .map do |k, rows|
              if k.match(/「([[:word:]]+).*」/)
                k = $1
              end
              fields = @target_fields.map { |e| rows[e].inject(:+) }
              [rows.size, *fields, k]
            end
            .sort_by { |e| key.match(/date/) ? e.last : -e.first }
  end

  def to_s
    if @stat
      ~<<-EOS
        amount\tsales\trevenue\ttitle
        #{"---"*20}
        #{ @stat.map { |d| "%i\t%.02f\t%.02f\t%s" % d }.join("\n") }
        #{"---"*20}
        #{"%i\t%.02f\t%.02f" % totals }
      EOS
    end
  end
end

sales = Sales.new(ARGV[1] || 'user_sales_data.csv')
sales.headers # => [:item_name, :buyer_name, :buyer_email, :purchase_date, :purchase_time, :price_, :net_revenue_, :street_address, :city, :billing_zip, :state, :country, :referrer, :refunded, :upc, :isrc]

key =
  case ARGV[0]
  when /title/i, /item/i
    :item_name
  when /date/i, /day/i
    :purchase_date
  when /buyer/i, /email/i
    :buyer_email
  else
    :item_name
  end

sales.stat_by(key)
puts sales
