# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
EventAttendance.destroy_all
Event.destroy_all
User.destroy_all

# Create sample users
users = User.create!([
  {
    name: "Alice Johnson",
    email: "alice@example.com",
    password: "password123",
    password_confirmation: "password123"
  },
  {
    name: "Bob Smith",
    email: "bob@example.com",
    password: "password123",
    password_confirmation: "password123"
  },
  {
    name: "Charlie Brown",
    email: "charlie@example.com",
    password: "password123",
    password_confirmation: "password123"
  },
  {
    name: "Diana Prince",
    email: "diana@example.com",
    password: "password123",
    password_confirmation: "password123"
  }
])

# Create sample events (mix of past and future)
events = Event.create!([
  {
    title: "Ruby on Rails Meetup",
    description: "Join us for an evening of Rails discussions, code reviews, and networking. We'll cover the latest Rails 8 features and best practices.",
    date: 1.week.from_now,
    location: "TechHub Downtown",
    creator: users[0]
  },
  {
    title: "PostgreSQL Workshop",
    description: "Deep dive into advanced PostgreSQL features including JSON columns, full-text search, and performance optimization.",
    date: 2.weeks.from_now,
    location: "Community College Room 205",
    creator: users[1]
  },
  {
    title: "Startup Networking Event",
    description: "Connect with fellow entrepreneurs, share ideas, and build meaningful relationships in the startup ecosystem.",
    date: 3.days.from_now,
    location: "Innovation Center",
    creator: users[2]
  },
  {
    title: "Web Development Bootcamp Graduation",
    description: "Celebrating our latest cohort of web developers! Come see their final projects and network with new talent.",
    date: 2.weeks.ago,
    location: "Coding Academy Main Hall",
    creator: users[3]
  },
  {
    title: "JavaScript Conference 2024",
    description: "A full day of JavaScript talks covering React, Node.js, TypeScript, and the future of web development.",
    date: 1.month.ago,
    location: "Convention Center",
    creator: users[0]
  }
])

# Create sample event attendances
EventAttendance.create!([
  { user: users[1], event: events[0] },  # Bob attending Alice's Rails meetup
  { user: users[2], event: events[0] },  # Charlie attending Alice's Rails meetup
  { user: users[3], event: events[0] },  # Diana attending Alice's Rails meetup
  
  { user: users[0], event: events[1] },  # Alice attending Bob's PostgreSQL workshop
  { user: users[2], event: events[1] },  # Charlie attending Bob's PostgreSQL workshop
  
  { user: users[0], event: events[2] },  # Alice attending Charlie's networking event
 { user: users[1], event: events[2] },  # Bob attending Charlie's networking event
 { user: users[3], event: events[2] },  # Diana attending Charlie's networking event
 
 { user: users[0], event: events[3] },  # Alice attended Diana's graduation (past event)
 { user: users[1], event: events[3] },  # Bob attended Diana's graduation (past event)
 { user: users[2], event: events[3] },  # Charlie attended Diana's graduation (past event)
 
 { user: users[1], event: events[4] },  # Bob attended Alice's JS conference (past event)
 { user: users[2], event: events[4] },  # Charlie attended Alice's JS conference (past event)
 { user: users[3], event: events[4] }   # Diana attended Alice's JS conference (past event)
])

puts "Created #{User.count} users, #{Event.count} events, and #{EventAttendance.count} attendances!"
puts "Upcoming events: #{Event.upcoming.count}"
puts "Past events: #{Event.past.count}"
