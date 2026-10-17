import 'package:flutter/material.dart';

class AppIcons {
  AppIcons._();
  static const IconData share = Icons.share_rounded;
  static const IconData displaySettings = Icons.tune_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData close = Icons.close_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData add = Icons.add_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteOutline = Icons.favorite_border_rounded;
  static const IconData home = Icons.home_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData bookmarkFilled = Icons.bookmark_rounded;
  static const IconData personOutline = Icons.person_outline_rounded;
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData logout = Icons.logout_rounded;

  // Automatically extracted icons
  static const IconData menuBookRounded = Icons.menu_book_rounded;
  static const IconData arrowBackRounded = Icons.arrow_back_rounded;
  static const IconData code = Icons.code;
  static const IconData visibilityOutlined = Icons.visibility_outlined;
  static const IconData radioButtonUnchecked = Icons.radio_button_unchecked;
  static const IconData list = Icons.list;
  static const IconData wifiRounded = Icons.wifi_rounded;
  static const IconData shieldOutlined = Icons.shield_outlined;
  static const IconData checkRounded = Icons.check_rounded;
  static const IconData bookmark = Icons.bookmark;
  static const IconData chatBubbleOutlineRounded =
      Icons.chat_bubble_outline_rounded;
  static const IconData save = Icons.save;
  static const IconData brightnessAutoRounded = Icons.brightness_auto_rounded;
  static const IconData bookmarkBorderRounded = Icons.bookmark_border_rounded;
  static const IconData rotateLeft = Icons.rotate_left;
  static const IconData settingsOutlined = Icons.settings_outlined;
  static const IconData formatItalic = Icons.format_italic;
  static const IconData fileOpen = Icons.file_open;
  static const IconData articleOutlined = Icons.article_outlined;
  static const IconData networkCheckRounded = Icons.network_check_rounded;
  static const IconData bookmarkAddOutlined = Icons.bookmark_add_outlined;
  static const IconData visibilityOffOutlined = Icons.visibility_off_outlined;
  static const IconData gridViewRounded = Icons.grid_view_rounded;
  static const IconData editAlt = Icons.edit;
  static const IconData personAlt = Icons.person;
  static const IconData linkRounded = Icons.link_rounded;
  static const IconData formatBold = Icons.format_bold;
  static const IconData moreVert = Icons.more_vert;
  static const IconData notificationsActiveOutlined =
      Icons.notifications_active_outlined;
  static const IconData wbSunnyOutlined = Icons.wb_sunny_outlined;
  static const IconData nightlightRound = Icons.nightlight_round;
  static const IconData inventory2Outlined = Icons.inventory_2_outlined;
  static const IconData arrowForwardIosRounded =
      Icons.arrow_forward_ios_rounded;
  static const IconData menuBookOutlined = Icons.menu_book_outlined;
  static const IconData thumbUpOutlined = Icons.thumb_up_outlined;
  static const IconData imageOutlined = Icons.image_outlined;
  static const IconData downloadAlt = Icons.download;
  static const IconData imageRounded = Icons.image_rounded;
  static const IconData link = Icons.link;
  static const IconData visibility = Icons.visibility;
  static const IconData visibilityOff = Icons.visibility_off;
  static const IconData minimizeRounded = Icons.minimize_rounded;
  static const IconData alternateEmailRounded = Icons.alternate_email_rounded;
  static const IconData boltRounded = Icons.bolt_rounded;
  static const IconData closeAlt = Icons.close;
  static const IconData clearAll = Icons.clear_all;
  static const IconData mailOutlineRounded = Icons.mail_outline_rounded;
  static const IconData thumbUp = Icons.thumb_up;
  static const IconData formatStrikethrough = Icons.format_strikethrough;
  static const IconData iosShareRounded = Icons.ios_share_rounded;
  static const IconData checkCircleRounded = Icons.check_circle_rounded;
  static const IconData expandMoreRounded = Icons.expand_more_rounded;
  static const IconData textFields = Icons.text_fields;
  static const IconData volumeUpOutlined = Icons.volume_up_outlined;
  static const IconData formatQuoteRounded = Icons.format_quote_rounded;
  static const IconData wifiOffRounded = Icons.wifi_off_rounded;
  static const IconData starRounded = Icons.star_rounded;
  static const IconData starOutlineRounded = Icons.star_outline_rounded;
  static const IconData chevronLeftRounded = Icons.chevron_left_rounded;
  static const IconData chevronRightRounded = Icons.chevron_right_rounded;
  static const IconData playArrowRounded = Icons.play_arrow_rounded;
  static const IconData pauseRounded = Icons.pause_rounded;

  // Category Icons
  static const IconData technology = Icons.memory_rounded;
  static const IconData science = Icons.science_rounded;
  static const IconData businessEntrepreneurship = Icons.business_center_rounded;
  static const IconData personalDevelopment = Icons.self_improvement_rounded;
  static const IconData healthWellness = Icons.health_and_safety_rounded;
  static const IconData educationLearning = Icons.school_rounded;
  static const IconData newsCurrentEvents = Icons.newspaper_rounded;
  static const IconData politics = Icons.gavel_rounded;
  static const IconData financeInvesting = Icons.account_balance_wallet_rounded;
  static const IconData lifestyle = Icons.local_cafe_rounded;
  static const IconData travelCulture = Icons.travel_explore_rounded;
  static const IconData foodCooking = Icons.restaurant_rounded;
  static const IconData sports = Icons.sports_soccer_rounded;
  static const IconData entertainmentMovies = Icons.movie_rounded;
  static const IconData booksLiterature = Icons.menu_book_rounded;
  static const IconData artDesign = Icons.palette_rounded;
  static const IconData programmingSoftwareDevelopment = Icons.code_rounded;
  static const IconData history = Icons.history_edu_rounded;
  static const IconData psychology = Icons.psychology_rounded;
  static const IconData environmentSustainability = Icons.eco_rounded;

  static IconData getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Technology':
        return technology;
      case 'Science':
        return science;
      case 'Business & Entrepreneurship':
      case 'Business':
        return businessEntrepreneurship;
      case 'Personal Development':
        return personalDevelopment;
      case 'Health & Wellness':
      case 'Health':
        return healthWellness;
      case 'Education & Learning':
      case 'Education':
        return educationLearning;
      case 'News & Current Events':
        return newsCurrentEvents;
      case 'Politics':
        return politics;
      case 'Finance & Investing':
      case 'Finance':
        return financeInvesting;
      case 'Lifestyle':
        return lifestyle;
      case 'Travel & Culture':
      case 'Culture':
        return travelCulture;
      case 'Food & Cooking':
        return foodCooking;
      case 'Sports':
        return sports;
      case 'Entertainment & Movies':
        return entertainmentMovies;
      case 'Books & Literature':
        return booksLiterature;
      case 'Art & Design':
        return artDesign;
      case 'Programming & Software Development':
        return programmingSoftwareDevelopment;
      case 'History':
        return history;
      case 'Psychology':
        return psychology;
      case 'Environment & Sustainability':
        return environmentSustainability;
      default:
        return Icons.category_rounded;
    }
  }
}
