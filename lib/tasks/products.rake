MyProducts = [
  {
    name: "Cuenta Tutor Básico",
    category: "payments_website",
    description:"basic account tutor",
    key: Rails.application.secrets.basic_account_tutor_key
  },
  {
    name: "Cuenta Tutor Premium",
    category: "payments_website",
    description:"premium account tutor",
    key: Rails.application.secrets.premiun_account_tutor_key
  },
  {
    name: "Agregar cliente atravez de pago",
    category: "payments_website",
    description:"add client by payment",
    key: Rails.application.secrets.add_client_to_tutor_key
  }
]

namespace :products do
  task create: :environment do
    products_db = Product.all.map(&:name)
    MyProducts.each do |product|
      unless products_db.include?(product[:name])
        Product.create!(product)
        puts "Product: #{product[:name]}"
      end
    end
  end
end

namespace :products do
  task update: :environment do
    products_db = Product.all.map(&:name)
    MyProducts.each do |product|
      if products_db.include?(product[:name])
        myProduct = Product.find_by_name(product[:name])
        myProduct.update(product)
        puts "Product updated: #{product[:name]}"
      end
    end
  end
end
