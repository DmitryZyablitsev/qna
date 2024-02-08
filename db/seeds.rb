User.destroy_all
Question.destroy_all

User.create!(email: 'user@develop.com', password: '12345678')

q_rails = Question.create!([
                             { title: 'rails_6', body: 'What JS working in rails 6?' },
                             { title: 'Slim', body: 'What Slim working in rails 6?' },
                             { title: 'Ruby 3.0.0', body: 'What updated whis ruby 2.6 on 3.0.0' }
                           ])

q_rails.first.answers.create!([{ body: 'sdsfsfsfsdf' }, { body: 'aaaaaaaaaaa' }, { body: 'vvvvvvvvvvvv' }])
