describe "Wallet" do
  specify "should supply arbitrary amount of money in any of the defined currencies"
    supply_amount_to_wallet(100, :pln)
    supply_amount_to_wallet(200, :usd)
    get_pln_from_wallet.should == 100
    get_usd_from_wallet.should == 200
    get_eur_from_wallet.should == 0
  end

  specify "allows to convert available money from one currency to another according to a currency exchange table"
    supply_amount_to_wallet(1000, :pln)
    set_exchange_table({
      pln: 1,
      usd: 2.72,
      eur: 4.67
    })
    convert(amount(272, :pln), :usd)
    get_usd_from_wallet.should == 100
    get_pln_from_wallet.should == 728
  endo

  specify "allows to buy and sell stocks according to stock exchange rates"
    supply_amount_to_wallet(1000, :pln)
    set_stock_exchange_rates({
      first: amount(1.5, :pln),
      second: amount(3.75, :pln)
    })
    buy_stock(:first, 10)
    get_stock_amount(:first).should == 10
    sell_stock(:first, 5)
    get_stock_amount(:first).should == 5

    get_pln_from_wallet.should == 995.5
  end

  specify "should make it able to transfer money back to user bank account"
    supply_amount_to_wallet(1000, :pln)
    upload_money
  end


end
