class SitePresenter < SimpleDelegator
  def contact_displayable?
    contact_phone.present? || contact_email.present? || contact_name.present?
  end

  def phone_to_call
    if contact_phone_ext.present?
      "#{contact_phone},#{contact_phone_ext}"
    else
      contact_phone
    end
  end

  def phone_as_text
    if contact_phone_ext.present?
      "#{contact_phone} ##{contact_phone_ext}"
    else
      contact_phone
    end
  end
end
