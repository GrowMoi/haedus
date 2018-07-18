achievements_params = [
  {
    name: "Contenidos aprendidos",
    description: "Han sido aprendidos los primeros 4 contenidos",
    category: "content",
    settings: {
      quantity: 4,
      branch: "any"
    },
    number: 1
  },
  {
    name: "Contenidos aprendidos rama Lenguaje",
    description: "Han sido aprendidos 20 contenidos de la rama Lenguaje",
    category: "branch",
    settings: {
      quantity: 20,
      branch: "Lenguaje"
    },
    number: 2
  },
  {
    name: "Contenidos aprendidos rama Arte",
    description: "Han sido aprendidos 20 contenidos de la rama Arte",
    category: "branch",
    settings: {
      quantity: 20,
      branch: "Arte"
    },
    number: 3
  },
  {
    name: "Contenidos aprendidos rama Aprender",
    description: "Han sido aprendidos 20 contenidos de la rama Aprender",
    category: "branch",
    settings: {
      quantity: 20,
      branch: "Aprender"
    },
    number: 4
  },
  {
    name: "Contenidos aprendidos rama Naturaleza",
    description: "Han sido aprendidos 20 contenidos de la rama Naturaleza",
    category: "branch",
    settings: {
      quantity: 20,
      branch: "Naturaleza"
    },
    number: 5
  },
  {
    name: "Contenidos aprendidos en total",
    description: "Todos los contenidos han sido aprendidos",
    category: "content",
    settings: {
      quantity: "All",
      branch: "All"
    },
    number: 6
  },
  {
    name: "Contenidos aprendidos en cada neurona pública",
    description: "Al menos un contenido ha sido aprendido en cada neurona pública",
    category: "content",
    settings: {
      quantity: 1,
      branch: "All"
    },
    number: 7
  },
  {
    name: "Tests sin errores",
    description: "Han sido completados 4 test sin errores",
    category: "test",
    settings: {
      quantity: 4,
      continuous: true
    },
    number: 8
  },
  {
    name: "Tests desplegados",
    description: "Han sido desplegados 25 test sin errores",
    category: "test",
    settings: {
      quantity: 25,
      continuous: false
    },
    number: 9
  },
  {
    name: "Final del Juego",
    description: "El usuario ha alcanzado el 9 nivel",
    category: "test",
    settings: {
      level: 9
    },
    number: 10
  }
]

namespace :achievements do
  task create: :environment do
    achievements_db_numbers = AdminAchievement.all.map(&:number)
    achievements_tasks = achievements_params
    achievements_tasks.each do |task_params|
      unless achievements_db_numbers.include?(task_params[:number])
        AdminAchievement.create!(task_params)
        puts "created: #{task_params[:name]}"
      end
    end
  end

  #assign achievements just for active users
  task set_user_achievements: :environment do
    clients_ids = ContentLearning.all.map(&:user_id).uniq.sort
    clients = User.where(id: clients_ids)
    achievements_db = AdminAchievement.all
    clients.each do |client|
      my_achievements = client.user_admin_achievements.map(&:admin_achievement_id)
      no_achievements = achievements_db.reject{ |x| my_achievements.include? x.id }
      assign_achievement(no_achievements, client)
    end
  end
end


def assign_achievement(achievements, user)
  achievements.each do |achievement|
    if achievement.user_win_achievement?(user)
      UserAdminAchievement.create!(user_id: user.id, admin_achievement_id: achievement.id)
      puts "user: #{user.name}, user_id: #{user.id}, achievement assign: #{achievement.name}"
    end
  end
end
