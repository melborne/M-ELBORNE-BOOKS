#!/usr/bin/env ruby
# encoding: UTF-8


# Gumraod Sales CSV Statistic Library
# by melborne
#
# see: thor help gumroad:sales

require "csv"

class CSV::Table
  def group_by(&blk)
    Hash[ super.map { |k, v| [k, CSV::Table.new(v)]  }]
  end
end

module GumRoad
end

class GumRoad::Sales
  def initialize(csv, target=[:price_, :net_revenue_])
    @table = CSV.table(csv)
    @target_fields = target
    @stat = nil
  end

  def headers
    fields = @target_fields.map { |s| "#{s}".sub(/_$/, '') }
    [:amount, *fields]
  end

  def totals
    fields = @target_fields.map { |f| @table[f].inject(:+) }
    [@table.size, *fields]
  end

  def stat_by(key)
    @stat = begin
      @table.group_by { |t| t[key] }
            .map do |k, rows|
              fields = @target_fields.map { |f| rows[f].inject(:+) }
              [rows.size, *fields, k]
            end
            .sort_by { |e| key.match(/date/) ? e.last : -e.first }
    end
    self
  end

  def to_s
    if @stat
      border = "---" * 20
      <<-EOS
#{ headers.join("\t") }
#{ border }
#{ @stat.map { |d| "%i\t%.02f\t%.02f\t%s" % d }.join("\n") }
#{ border }
#{ "%i\t%.02f\t%.02f" % totals }
      EOS
    end
  end
end


require "thor"
class Gumroad < Thor
  desc "sales SALES_FILE", "listing sales"
  method_option :date, :aliases => "-d", :desc => "sales listed by date"
  method_option :user, :aliases => "-u", :desc => "sales listed by user"
  def sales(csv='sales_data.csv')
    sales = GumRoad::Sales.new(csv)
    key =
      if    options[:date] then :purchase_date
      elsif options[:user] then :buyer_email
      else  :item_name
      end
    puts sales.stat_by(key)
  end
end

