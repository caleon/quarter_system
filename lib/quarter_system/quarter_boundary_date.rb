class QuarterBoundaryDate < Date
  # args for Date#new are year, month, day, and an optional "day of calendar reform"
  # just not gonna worry about day of calendar reform at all.
  def self.new(*args)
    args.unshift(this_year) if args.size < 2
    super(*args)
  end
end
class QuarterBeginDate < QuarterBoundaryDate; end
class QuarterEndDate   < QuarterBoundaryDate
  def self.new(*args)
    super.end_of_month
  end
end