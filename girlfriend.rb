require 'rubygems'
require './lib/headless'
require 'selenium-webdriver'
require 'webdriver-user-agent'

unless ARGV.length == 2
  puts "Dude, your girl is waiting. But first Find her name nl.bongacams.com "
  puts "Usage: ruby girlfriend.rb her_name love_duration_in_milliseconds \n"
  exit
end

headless_toggle = true
love_duration = ARGV[1]
girl_name = ARGV[0]
#girl = "https://nl.bongacams.com/pippalee"
girl = "https://nl.bongacams.com/#{girl_name}"

if (headless_toggle)
  headless = Headless.new(:video => { :frame_rate => 30, :codec => 'libx264' })
  headless.start
  headless.video.start_capture
end
driver = Webdriver::UserAgent.driver(:browser => :chrome, :agent => :ipad, :orientation => :landscape)

def click18(driver) 
  begin
  element = driver.find_element(:xpath, "//*[@id=\"popup_18_plus\"]/div[2]/div[2]/a[1]")  
  element.click
rescue Selenium::WebDriver::Error::NoSuchElementError  
  puts "no 18 years element"
  end
end


def hideShit(driver)
 # $('.chat-panel').hide()
 # $('#video-panel-wrap').css('width', '100%')
  driver.execute_script("$('.chat-panel').hide()")
  driver.execute_script("$('#displayHLS').css('width','1280px')")
  driver.execute_script("$('#stream-container').css('overflow','visible')")
  driver.execute_script("$('.performer-frame').css('overflow','visible')")
  driver.execute_script("$('.performer-video').css('overflow','visible')")
  driver.execute_script("$('.video-panel').css('overflow','visible')")
  
  driver.execute_script("$('#free_tokens_sticker2').hide()")
  driver.execute_script("$('#streaming-container').css('width', '1280px')")

  driver.execute_script("$('#video-panel-wrap').css('width', '100%')")
  driver.execute_script("$('.performer-video').attr('title', '')")
end

def routine(driver)
  driver.execute_script("$('.performer-video').attr('title', '')")
  click18(driver)
  driver.execute_script("$('.performer-video').attr('title', '')")
  sleep 2
  hideShit(driver)
end

if headless_toggle
  Process.spawn("unclutter","-display",":99", "-idle", "0.01", "-root")
end

driver.navigate.to girl
sleep 1
driver.manage.window.resize_to(1280, 720)
driver.execute_script("window.resizeTo(screen.width,screen.height)")


routine(driver)

sleep love_duration

if headless_toggle 
  headless.video.stop_and_save("girlstapes/girl#{girl_name}-#{Time.now.to_i}.mov")
  puts driver.title
  headless.destroy
end
