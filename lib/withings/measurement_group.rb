class Withings::MeasurementGroup
  ATTRIBUTION_DEVICE = 0
  ATTRIBUTION_DEVICE_AMBIGUOUS = 1
  ATTRIBUTION_DEVICE_MANUALLY = 2
  ATTRIBUTION_DEVICE_MANUALLY_DURING_CREATION = 4

  CATEGORY_MEASURE = 1
  CATEGORY_TARGET = 2

  TYPE_WEIGHT = 1                     # kg
  TYPE_SIZE = 4                       # m
  TYPE_FAT_FREE_MASS_WEIGHT = 5       # kg
  TYPE_FAT_RATIO = 6                  # % (unitless)
  TYPE_FAT_MASS_WEIGHT = 8            # kg
  TYPE_DIASTOLIC_BLOOD_PRESSURE = 9   # mmHg (min, lower)
  TYPE_SYSTOLIC_BLOOD_PRESSURE = 10   # mmHg (max, upper)
  TYPE_HEART_PULSE = 11               # bpm

  BLOOD_PRESSURE_MONITOR_TYPES = [
    TYPE_DIASTOLIC_BLOOD_PRESSURE,
    TYPE_SYSTOLIC_BLOOD_PRESSURE,
    TYPE_HEART_PULSE
  ]
  
  SCALE_TYPES = [
    TYPE_WEIGHT,
    TYPE_SIZE,
    TYPE_FAT_FREE_MASS_WEIGHT,
    TYPE_FAT_RATIO,
    TYPE_FAT_MASS_WEIGHT
  ]

  attr_reader :group_id, :attribution, :taken_at, :category
  attr_reader :weight, :size, :fat, :ratio, :fat_free, :diastolic_blood_pressure, :systolic_blood_pressure, :heart_pulse
  def initialize(params)
    params = params.stringify_keys
    @group_id = params['grpid']
    @attribution = params['attrib']
    @taken_at = Time.at(params['date'])
    @category = params['category']
    params['measures'].each do |measure|
      value = (measure['value'] * 10 ** measure['unit']).to_f
      case measure['type']
      when TYPE_WEIGHT then @weight = value
      when TYPE_SIZE then @size = value
      when TYPE_FAT_MASS_WEIGHT then @fat = value
      when TYPE_FAT_RATIO then @ratio = value
      when TYPE_FAT_FREE_MASS_WEIGHT then @fat_free = value
      when TYPE_DIASTOLIC_BLOOD_PRESSURE then @diastolic_blood_pressure = value
      when TYPE_SYSTOLIC_BLOOD_PRESSURE then @systolic_blood_pressure = value
      when TYPE_HEART_PULSE then @heart_pulse = value
      end
    end
  end

  def created_at
    $stderr.puts "created_at has been deprecated in favour of taken_at. Please updated your code."
  end

  def measure?
    self.category == CATEGORY_MEASURE
  end

  def target?
    self.category == CATEGORY_TARGET
  end

  def to_s
    "[weight: #{self.weight}, fat: #{self.fat}, size: #{self.size}, ratio: #{self.ratio}, free: #{self.fat_free}, Blood pressure: #{self.diastolic_blood_pressure}/#{self.systolic_blood_pressure} @ #{self.heart_pulse}, iD: #{self.group_id} (taken at: #{self.taken_at.strftime("%d.%m.%Y %H:%M:%S")})]"
  end

  def to_h
    {
      weight: weight,
      size: size,
      fat: fat,
      ratio: ratio,
      category: category,
      group_id: group_id,
      fat_free: fat_free,
      diastolic_blood_pressure: diastolic_blood_pressure,
      systolic_blood_pressure: systolic_blood_pressure,
      heart_pulse: heart_pulse,
      taken_at: taken_at
    }
  end

  def mongoize
    to_h
  end

  def inspect
    to_s
  end
end
