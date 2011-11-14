falsy = (fn) ->
  try
    return fn()
  catch err
    return false
  return

this.getE164PhoneNumberWithMeta = getE164PhoneNumberWithMeta = (str, cc, ndc) ->
  cc = "#{cc ? ""}"
  ndc = "#{ndc ? ""}"
  util = i18n.phonenumbers.PhoneNumberUtil
  inst = util.getInstance()
  e164 = i18n.phonenumbers.PhoneNumberFormat.E164
  num = util.extractPossibleNumber(str)
  if cc && /^[\d]+$/.test("#{cc ? ""}")
    regionCode = inst.getRegionCodeForCountryCode(+cc)
  else if inst.getMetadataForRegion(cc)
    regionCode = cc
  
  fixnumber = (phone_obj) ->
    if phone_obj
      return phone_obj if inst.isValidNumber(phone_obj)
      if ndc && inst.getLengthOfNationalDestinationCode(phone_obj) != ndc.length
        phone_obj.setNationalNumber(+("#{ndc}#{inst.getNationalSignificantNumber(phone_obj)}"))
        return phone_obj if inst.isValidNumber(phone_obj)
    return
    
  complete = (phone_obj) ->
    if phone_obj
      formatted = inst.format(phone_obj, e164)
      cc = "#{phone_obj.getCountryCode() ? ""}"
      ndc = "#{inst.getNationalSignificantNumber(phone_obj) ? ""}".substring(0,inst.getLengthOfNationalDestinationCode(phone_obj))
      return [ formatted, cc, ndc ]
    else
      return []
  
  attempt = (fn) -> complete(fixnumber(falsy(fn)))
  res = attempt () -> inst.parse(num)
  return res if res[0]
  res = attempt () -> inst.parse(num, regionCode)
  return res if res[0]
  []

this.getE164PhoneNumber = (str, cc, ndc) -> getE164PhoneNumberWithMeta(str, cc, ndc)[0]
