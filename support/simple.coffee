falsy = (fn) ->
  try
    return fn()
  catch err
    return false
  return

this.getE164PhoneNumber = (str, cc, ndc) ->
  cc = "#{cc ? ""}"
  ndc = "#{ndc ? ""}"
  util = i18n.phonenumbers.PhoneNumberUtil
  inst = util.getInstance()
  e164 = i18n.phonenumbers.PhoneNumberFormat.E164
  num = util.extractPossibleNumber(str)
  if cc && /^[\d]+$/.test(cc)
    regionCode = inst.getRegionCodeForCountryCode(+cc)
  else if inst.getMetadataForRegion(cc)
    regionCode = cc
  
  fixnumber = (phone_obj) ->
    if phone_obj
      return phone_obj if inst.isValidNumber(phone_obj)
      if ndc && inst.getLengthOfNationalDestinationCode(phone_obj) != ndc.length
        phone_obj.setNationalNumber(+("#{ndc}#{phone_obj.getNationalNumber()}"))
        return phone_obj if inst.isValidNumber(phone_obj)
    return
    
  format = (phone_obj) ->
    return inst.format(phone_obj, e164) if phone_obj
    return
  
  attempt = (fn) -> format(fixnumber(falsy(fn)))
  phone = attempt () -> inst.parse(num)
  return phone if phone
  phone = attempt () -> inst.parse(num, regionCode)
  return phone if phone
  return
