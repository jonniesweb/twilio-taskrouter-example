require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'json'
require 'byebug'

set :port, 8080

# Get your Account Sid and Auth Token from twilio.com/user/account
account_sid = 'ACxxx'
auth_token = 'xxx'
workspace_sid = 'WSxxx'
workflow_sid = 'WWxxx'
post_work_activity_sid = 'WAxxx'
twilio_phone_number = "+1xxx"

client = Twilio::REST::Client.new account_sid, auth_token, workspace_sid

post '/assignment_callback' do
  content_type :json
  {"instruction" => "dequeue", "from" => twilio_phone_number, "post_work_activity_sid" => post_work_activity_sid}.to_json
end

get '/create-task' do
  task = client.taskrouter.workspaces.list.first.tasks.create workflow_sid: workflow_sid, attributes: '{"selected_language":"es"}'
  task.attributes
end

get '/accept-reservation' do
  task_sid = params[:task_sid]
  reservation_sid = params[:reservation_sid]

  workspace = client.taskrouter.workspaces(workspace_sid)
  task = workspace.tasks(task_sid)
  reservation = task.reservations(reservation_sid)

  reservation.update(reservation_status: 'accepted')

  puts "accepted reservation task: #{task_sid} reservation: #{reservation_sid}"
  reservation.fetch.worker_name
end

get '/incoming_call' do
  Twilio::TwiML::VoiceResponse.new do |r|
    r.gather :num_digits => '1', :action => '/enqueue_call', :method => 'post', :timeout => 5 do |g|
      g.say 'Para Español oprime el uno.', :language => 'es'
      g.say 'For English, please hold or press two.', :language => 'en'
    end
  end.to_s
end

post '/enqueue_call' do
  digit_pressed = params[:Digits]
  if digit_pressed.to_i == 1
    language = "es"
  else
    language = "en"
  end

  attributes = '{"selected_language":"' + language + '"}'

  Twilio::TwiML::VoiceResponse.new do |r|
    r.enqueue :workflow_sid => workflow_sid do |e|
      e.task attributes
    end
  end.to_s
end

get '/agents' do
  worker_sid = params['WorkerSid']

  capability = Twilio::JWT::TaskRouterCapability.new account_sid, auth_token, workspace_sid, worker_sid

  policies = Twilio::JWT::TaskRouterCapability::TaskRouterUtils.worker_policies(workspace_sid, worker_sid)

  # this custom one is required for a worker to update their current activity
  policies << Twilio::JWT::TaskRouterCapability::Policy.new(
    Twilio::JWT::TaskRouterCapability::TaskRouterUtils.worker(workspace_sid, worker_sid), 'POST', true
  )

  # print JWT allowed urls
  puts policies.map(&:url)

  policies.each do |policy|
    capability.add_policy(policy)
  end

  erb :agent, locals: { worker_token: capability.to_s }
end
