#! /usr/bin/ruby

class Integer
  def jpy_comma
    self.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end
end

module IncomeTax
  def self.calc(taxable_income)
    num = 0

    if (0..1950000).include?(taxable_income)
      num = taxable_income * 0.05
    elsif (1950000..3300000).include?(taxable_income)
      num = taxable_income * 0.1 - 97500
    elsif (3300000..6950000).include?(taxable_income)
      num = taxable_income * 0.2 - 427500
    elsif (6950000..9000000).include?(taxable_income)
      num = taxable_income * 0.23 - 636000
    elsif (9000000..18000000).include?(taxable_income)
      num = taxable_income * 0.33 - 1536000
    elsif (18000000..40000000).include?(taxable_income)
      num = taxable_income * 0.4 - 2796000
    else
      num = taxable_income * 0.45 - 4796000
    end

    return num.to_i
  end
end

def print_result(str, num)
  printf("%s%10s\n", str, num.jpy_comma)
end

num = 0
if ARGV.size > 0
  num = ARGV[0]
else
  print "所得課税を入力してください : "
  num = gets.chomp
end

taxable_income = num.to_i
it = IncomeTax.calc(taxable_income)
reconstruction_tax = (it * 0.021).to_i / 100 * 100

print_result("所得課税           : ", taxable_income)
print_result("所得税  合計       : ", it + reconstruction_tax)
print_result(" |- 所得税         : ", it)
print_result(" `- 復興特別所得税 : ", reconstruction_tax)

