# PayboxMoney
Тонкая обертка над сервисами [paybox.money](https://paybox.money/).

## Установка

Добавьте гем в Gemfile:

```ruby
gem 'paybox_money'
```

И затем установите:

    $ bundle

Или установите вручную:

    $ gem install paybox_money

## Платежи (Payment)
Стандартные платежи с переходом на платежный шлюз Paybox.

### Инициализация платежа (Payment::Init)

Пример инициализации платежа.

```ruby
init = PayboxMoney::Payment::Init.new(
  amount: '1000', # Amount to pay
  description: 'Test', # Payment description
  merchant_id: 'your_merchant_id', # Provided by paybox
  language: 'ru', # Gateway interface language
  secret_key: 'your_secret_key' # Provided by paybox
)

if init.success?
  init.response.redirect_url # "https://www.paybox.kz/payment.html?customer=bf2e2..."
else
  init.response.error_description # "Неверный номер магазина"
end
```

Любые параметры можно вынести в параметры по умолчанию, чтобы не передавать их постоянно. При использовании rails лучше всего создать файл `paybox_money.rb` в `config/initializers`. Например:
```ruby
PayboxMoney::Payment.default_params(
  {
    merchant_id: 'your_merchant_id',
    language: 'ru',
    secret_key: 'your_secret_key'
  }
)
```
Теперь при инициализации платежа передавать их не нужно:

```ruby
init = PayboxMoney::Payment::Init.new(
  amount: '1000'
  description: 'Test'
)

if init.success?
  init.response.redirect_url
else
  init.response.error_description
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/paybox_money. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
