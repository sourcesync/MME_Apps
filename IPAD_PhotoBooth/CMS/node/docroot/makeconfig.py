CONFIG_NAME = "mme.json"

import json

settings = {\
	"img_start_portrait": "screens/00-Photomation-iPad-Start-Screen-Vertical.jpg", \
	"img_start_landscape":"screens/00-Photomation-iPad-Start-Screen-Horizontal.jpg", \
	"img_email_portrait": "screens/03-Photomation-iPad-Enter-Email-Screen-Vertical.jpg", \
	"img_email_landscape": "screens/03-Photomation-iPad-Entyer-Email-Horizontal.jpg", \
	"img_takephoto_manual_portrait":"screens/04-Photomation-iPad-TakePhoto-Manual-Screen-Vertical.jpg", \
	"img_takephoto_manual_landscape":"screens/04-Photomation-iPad-TakePhoto-Manual-Screen-Horizontal.jpg", \
	"img_takephoto_auto_portrait":"screens/04-Photomation-iPad-TakePhoto-Auto-Screen-Vertical2.jpg", \
	"img_takephoto_auto_landscape":"screens/04-Photomation-iPad-TakePhoto-Auto-Screen-Horizontal.jpg", \
	"img_yourphoto_manual_portrait": "screens/5b-Photomation-iPad-Your-Photo-Screen-Manual-4Up-Vertical.jpg", \
	"img_yourphoto_manual_landscape": "screens/05-Photomation-iPad-Select-Photo-Screen-Manual-4up-Horizontal.jpg", \
	"img_yourphoto_auto_portrait": "screens/5-Photomation-iPad-your-Photo-Screen-Vertical.jpg", \
	"img_yourphoto_auto_landscape": "screens/5-Photomation-iPad-your-Photo-Screen-Horizontal.jpg", \
	"img_selectedphoto_portrait" : "screens/05b-Photomation-iPad-Selected-Photo-Screen-Vertical.jpg", \
	"img_selectedphoto_landscape": "screens/05b-Photomation-iPad-Selected-Photo-Screen-Horizontal.jpg", \
	"img_efx_portrait":"screens/6-Photomation-iPad-EFX-Photo-Screen-Vertical.jpg", \
	"img_efx_landscape":"screens/6-Photomation-iPad-EFX-Photo-Screen-Horizontal.jpg", \
	"img_share_portrait":"screens/7-Photomation-iPad-SHARE-Photo-Screen-Vertical.jpg",\
	"img_share_landscape":"screens/7-Photomation-iPad-SHARE-Photo-Screen-Horizontal.jpg",\
	"img_twitter_portrait":"screens/7a-Photomation-iPad-Enter-Twitter-Login-Screen-Vertical.jpg",\
	"img_twitter_landscape":"screens/07a-Photomation-iPad-Enter-Twitter-Login-Horizontal.jpg",\
	"img_facebook_portrait":"screens/7b-Photomation-iPad-Enter-FB-Login-Screen-Vertical.jpg",\
	"img_facebook_landscape":"screens/07b-Photomation-iPad-Enter-FB-Login-Horizontal.jpg",\
	"img_flickr_portrait":"screens/7c-Photomation-iPad-Enter-Flickr-Login-Screen-Vertical.jpg",\
	"img_flickr_landscape":"screens/07c-Photomation-iPad-Enter-Flickr-Login-Horizontal.jpg",\
	"img_gallery_portrait":"screens/8-Photomation-iPad-Gallery-Main-Screen-Vertical.jpg",\
	"img_gallery_landscape":"screens/8-Photomation-iPad-Gallery-Main-Screen-Horizontal.jpg",\
	"img_gallery_select_portrait":"screens/8-Photomation-iPad-Gallery-Single-Pic-Screen-Vertical.jpg",\
	"img_gallery_select_landscape":"screens/8-Photomation-iPad-Gallery-Single-Pic-Screen-Horizontal.jpg",\
	"img_thanks_portrait":"screens/9-Photomation-iPad-Thank-You-Vertical.jpg",\
	"img_thanks_landscape":"screens/9-Photomation-iPad-Thank-You-Screen-Horizontal.jpg",\
	"img_email_template_portrait":"email/email_vert_1200x1800.jpg",\
	"img_email_template_landscape":"email/email_horiz_1800x1200.png",\
	"img_email_watermark_portrait":"email/watermark400x600.png",\
	"img_email_watermark_landscape":"email/watermark600x400.png", \
	"snd_selection":"sounds/selection.wav",\
	"snd_picked":"sounds/picked.wav",\
	"snd_welcome":"sounds/welcome.wav",\
        "snd_enteremail":"sounds/enteremail.wav",\
        "snd_getready":"sounds/getready.wav",\
        "snd_countdown":"sounds/countdown.wav",\
        "snd_pickfavorite":"sounds/pickfavorite.wav",\
        "snd_selection":"sounds/share.wav",\
        "snd_selection":"sounds/efx.wav",\
        "snd_thanks":"sounds/thanks.wav",\
	"int_experience_timeout":10,\
	"int_max_takephotos":4,\
	"int_max_galleryphotos":16,\
	"str_facebook_post_message":"Photomation",\
	"str_twitter_post_message":"Photomation Rocks!",\
	"str_twitter_hastag":"PhotomationPhotobooth",\
	"str_email_send_url":"http://photomation.mmeink.com/ipad_app_send.php" 
}

config = { 'settings': settings }

f = open( CONFIG_NAME,'w')

json.dump( config, f )

f.close()

