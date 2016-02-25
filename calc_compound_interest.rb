#! /usr/bin/ruby

class Integer
  def jpy_comma
    self.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end
end

class String
  def width
    self.length + self.chars.reject(&:ascii_only?).length
  end

  def mb_ljust(width, padding=' ')
    output_width = self.width
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end

  def integer_str?()
    self =~ /^\d+$/
  end

  def float_str?()
    self =~ /^\d+\.\d+$/
  end
end

module CompoundInterest
  def self.calc(init_invest, years, annual_interest)
    result = init_invest * ( (1 + annual_interest.to_f / 100) ** (years) )
    return result.to_i
  end
end

def result_str(str, num, max_width=0)
  str = str.mb_ljust( max_width )

  tmp = nil
  if num.kind_of?(Integer)
    tmp = num.jpy_comma
  elsif num.kind_of?(Float)
    tmp = num
  else
    tmp = num.to_s
  end

  num_str = "%11s" % tmp

  return sprintf("%s : %s", str, num_str)
end

def get_input(str)
  print "#{str}を入力してください : "
  return gets.chomp
end

# 投資結果を算出
def calc_investment_result(init_invest, add_invest, years, annual_interest)
  results = Array.new( years )

  tmp = init_invest
  years.times do |n|
    tmp = (tmp * (1 + annual_interest.to_f / 100)).to_i
    results[n] = tmp
    tmp += add_invest
  end

  return results
end

required_items = %w(初期投資額 追加投資額(年間) 経過年数 年利(%))
max_width = required_items.map{|s| s.width }.max
input = Array.new( required_items.size )
if ARGV.size == input.size
  input = ARGV
else
  required_items.each_with_index do |item, idx|
    input[idx] = get_input(item)
  end
end

input.map! do |i|
  if i.integer_str?
    i.to_i
  elsif i.float_str?
    i.to_f
  else
    puts "引数エラー : #{i}"
    exit
  end
end

required_items.each_with_index do |item, idx|
  puts result_str(item, input[idx], max_width)
end

init_invest, add_invest, years, annual_interest = input

# 与えられた年利で運用結果を算出
results_investment = calc_investment_result(init_invest, add_invest, years, annual_interest)

# 普通預金で運用結果を算出
ORDINARY_DEPOSIT_RATE = 0.001
results_ordinary_deposit = calc_investment_result(init_invest, add_invest, years, ORDINARY_DEPOSIT_RATE)

# 定期預金で運用結果を算出
FIXED_DEPOSIT_RATE = 0.2
results_fixed_deposit = calc_investment_result(init_invest, add_invest, years, FIXED_DEPOSIT_RATE)

puts
max_width = ["運用結果 #{1.to_s.rjust(years.to_s.width)}年目".width, max_width].max
print result_str("年利(%)", "#{annual_interest}", max_width),
  result_str("", "#{FIXED_DEPOSIT_RATE}"),
  result_str("", "#{ORDINARY_DEPOSIT_RATE}"),
  "\n"

years.times do |n|
  str = "運用結果 #{(n + 1).to_s.rjust(years.to_s.width)}年目"
  print result_str(str, results_investment[n], max_width),
    result_str("", results_fixed_deposit[n]),
    result_str("", results_ordinary_deposit[n]),
    "\n"
end

