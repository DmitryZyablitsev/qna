Question.destroy_all
Question.create!([
                   { title: 'rails_6', body: 'What JS working in rails 6?' },
                   { title: 'Slim', body: 'What Slim working in rails 6?' },
                   { title: 'Ruby 3.0.0', body: 'What updated whis ruby 2.6 on 3.0.0' }
                 ])
