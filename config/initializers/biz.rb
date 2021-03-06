module Daikichi
  class Config
    Biz = ::Biz.configure do |config|
      config.hours = {
        mon: {'09:30' => '12:30', '13:30' => '18:30'},
        tue: {'09:30' => '12:30', '13:30' => '18:30'},
        wed: {'09:30' => '12:30', '13:30' => '18:30'},
        thu: {'09:30' => '12:30', '13:30' => '18:30'},
        fri: {'09:30' => '12:30', '13:30' => '18:30'}
      }

      config.holidays = YAML.safe_load(File.read("lib/tasks/holidays.yml"), permitted_classes: [Date]) if File.exist?("lib/tasks/holidays.yml")

      config.time_zone = 'Asia/Taipei'
    end
  end
end
