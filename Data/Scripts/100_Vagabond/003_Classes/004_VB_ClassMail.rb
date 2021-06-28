class MailBox
  attr_accessor(:personal)  # The personal mailbox for important mail
  attr_accessor(:global)    # The global mailbox for announcements
  
  def initialize()
    self.personal = []
    self.global = []
  end
end

class GearMail
  attr_accessor(:sender)  # The person who sent the message
  attr_accessor(:subject) # The subject of the message
  attr_accessor(:message) # The whole message (requires line breaks)
  attr_accessor(:read)    # If the message has been read yet
  attr_accessor(:picture) # An optional attached picture
  
  def initialize(sender, subject, message)
    self.sender  = sender
    self.subject = subject
    self.message = message
    self.read    = false
    self.picture = nil
  end
  
end

#Sender may also be a GearMail object if subject and message is left empty
def pbSendMail(mail,global=false,forceopen=false,notific=true,pic=nil)
  #if subject=="" && message==""
  #  subject = sender.subject
  #  message = sender.message
  #  sender = sender.sender
  #end
  #mail = GearMail.new(sender, subject, message)
  if pic!=nil
    mail.picture=pic
  end
  if !global
    $Trainer.mail.personal.push(mail)
  else
    $Trainer.mail.global.push(mail)
  end
  if notific
    pbMailNotification(mail,forceopen,global)
  end
  #if forceopen
  #  pbShowMail(true,global)
  #end
end

def pbHasMail?(mail, mailbox=1)
  ret = false
  mail_list = $Trainer.mail.personal
  mail_list = $Trainer.mail.global if mailbox==2
  for i in mail_list
    if mail.sender == i.sender && mail.subject == i.subject && mail.message == i.message
      ret = true
    end
  end
  return ret
end

def pbHasMailSimple(sender, subject, mailbox = 1)
  ret = false
  mail_list = $Trainer.mail.personal
  mail_list = $Trainer.mail.global if mailbox==2
  for i in mail_list
    if sender == i.sender && subject == i.subject
      ret = true
    end
  end
  return ret
end