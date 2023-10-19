#!/usr/bin/env ruby

Thread.abort_on_exception = true

$current = ""

Thread.new do
  loop do
    sleep 1
    text = if $current.start_with?('Time: ')
             $current.lines.drop(1).join
           else
             $current
           end
    puts "Time: #{Time.now}\n" + text
    STDOUT.flush
  end
end

STDIN.each do |line|
  $current = line
end
