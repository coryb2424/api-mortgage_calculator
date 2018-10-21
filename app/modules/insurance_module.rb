module InsuranceModule
  def calculate_insurance_amount(params)
    raw_mortgage_principal = params['asking_price'] - params['down_payment']
    dp_percentage = ratio_percentage(params['down_payment'], params['asking_price'])
    insurance_percentage = insurance_table(dp_percentage)

    (raw_mortgage_principal * (insurance_percentage / 100)).round(2)
  end

  def ratio_percentage(down_payment, asking_price)
    (down_payment / asking_price) * 100
  end

  def insurance_table(dp_percentage)
    if (5..9.99).cover? dp_percentage
      3.15
    elsif (10..14.99).cover? dp_percentage
      2.4
    elsif (15..19.99).cover? dp_percentage
      1.8
    else
      0
    end
  end
end
