import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutAppTitle;

  /// No description provided for @aboutDevs.
  ///
  /// In en, this message translates to:
  /// **'About Devs'**
  String get aboutDevs;

  /// No description provided for @aboutHadidiWinShort.
  ///
  /// In en, this message translates to:
  /// **'About Hadidi Win'**
  String get aboutHadidiWinShort;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Hadidi Win'**
  String get aboutUs;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories Installation'**
  String get accessories;

  /// No description provided for @accessoriesCodes.
  ///
  /// In en, this message translates to:
  /// **'Accessories Codes'**
  String get accessoriesCodes;

  /// No description provided for @accessoriesCodesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter accessory codes separated by commas (e.g. 1, 2, 3)'**
  String get accessoriesCodesHint;

  /// No description provided for @accessoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessoriesLabel;

  /// No description provided for @accessoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Accessory'**
  String get accessoryLabel;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addDoorOrWindow.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add a door or a window?'**
  String get addDoorOrWindow;

  /// No description provided for @addDoorOrWindowEstimateDesc.
  ///
  /// In en, this message translates to:
  /// **'Add a door or window and calculate\nits cost accurately and quickly'**
  String get addDoorOrWindowEstimateDesc;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @addFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Add first item'**
  String get addFirstItem;

  /// No description provided for @additionalInstructions.
  ///
  /// In en, this message translates to:
  /// **'Additional Instructions (Optional)'**
  String get additionalInstructions;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes or special requests'**
  String get additionalNotes;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Preferred installation dates, site details...'**
  String get additionalNotesHint;

  /// No description provided for @addMoreToCart.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMoreToCart;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your full address'**
  String get addressDescription;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @addressNameHint.
  ///
  /// In en, this message translates to:
  /// **'Address Name (e.g. Home, Office)'**
  String get addressNameHint;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @addRoundedLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Rounded'**
  String get addRoundedLabel;

  /// No description provided for @sectorsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Sectors'**
  String get sectorsCountLabel;

  /// No description provided for @pricePerSqmLabel.
  ///
  /// In en, this message translates to:
  /// **'/ m²'**
  String get pricePerSqmLabel;

  /// No description provided for @brandNameSkeleton.
  ///
  /// In en, this message translates to:
  /// **'Brand name is a bit long here'**
  String get brandNameSkeleton;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @egyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian'**
  String get egyptian;

  /// No description provided for @localLabel.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get localLabel;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @addToQuote.
  ///
  /// In en, this message translates to:
  /// **'Add to Quote'**
  String get addToQuote;

  /// No description provided for @afterSalesService.
  ///
  /// In en, this message translates to:
  /// **'After-Sales Service'**
  String get afterSalesService;

  /// No description provided for @afterSalesSub.
  ///
  /// In en, this message translates to:
  /// **'Lifetime support and maintenance for our clients.'**
  String get afterSalesSub;

  /// No description provided for @aiPowered.
  ///
  /// In en, this message translates to:
  /// **'AI Powered'**
  String get aiPowered;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @allNotificationsAlreadyRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications are already read'**
  String get allNotificationsAlreadyRead;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @announcement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcement;

  /// No description provided for @appIdentity.
  ///
  /// In en, this message translates to:
  /// **'App Identity'**
  String get appIdentity;

  /// No description provided for @appNameLabel.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appNameLabel;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadidi Win'**
  String get appTitle;

  /// No description provided for @areaDistrict.
  ///
  /// In en, this message translates to:
  /// **'Area / District'**
  String get areaDistrict;

  /// No description provided for @assembly.
  ///
  /// In en, this message translates to:
  /// **'Assembly'**
  String get assembly;

  /// No description provided for @blockNoise.
  ///
  /// In en, this message translates to:
  /// **'Block out noise for a peaceful home'**
  String get blockNoise;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @buildingNo.
  ///
  /// In en, this message translates to:
  /// **'Building No.'**
  String get buildingNo;

  /// No description provided for @buildNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumberLabel;

  /// No description provided for @buildWith.
  ///
  /// In en, this message translates to:
  /// **'Built With'**
  String get buildWith;

  /// No description provided for @calculateEstimate.
  ///
  /// In en, this message translates to:
  /// **'Calculate your estimate'**
  String get calculateEstimate;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get cartErrorBody;

  /// No description provided for @categoryAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get categoryAccessories;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryDoors.
  ///
  /// In en, this message translates to:
  /// **'Doors'**
  String get categoryDoors;

  /// No description provided for @categoryGlass.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get categoryGlass;

  /// No description provided for @categoryProfiles.
  ///
  /// In en, this message translates to:
  /// **'UPVC Profiles'**
  String get categoryProfiles;

  /// No description provided for @categoryWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get categoryWindows;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Your Password'**
  String get changePassword;

  /// No description provided for @chatSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team now'**
  String get chatSupport;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @checkoutBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to proceed with the checkout? Your cart will be cleared.'**
  String get checkoutBody;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout Confirmation'**
  String get checkoutTitle;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseGallery;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @clearAllConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all items?'**
  String get clearAllConfirmation;

  /// No description provided for @clearAllItemsFromCartConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all items from the cart?'**
  String get clearAllItemsFromCartConfirmation;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorSand.
  ///
  /// In en, this message translates to:
  /// **'Sand'**
  String get colorSand;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorWood.
  ///
  /// In en, this message translates to:
  /// **'Wood'**
  String get colorWood;

  /// No description provided for @commonQuestions.
  ///
  /// In en, this message translates to:
  /// **'Common questions and answers'**
  String get commonQuestions;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completedTimeline.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTimeline;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmAndSendRequest.
  ///
  /// In en, this message translates to:
  /// **'Confirm and Send Request'**
  String get confirmAndSendRequest;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @contactSupportCenter.
  ///
  /// In en, this message translates to:
  /// **'Contact our 24/7 center'**
  String get contactSupportCenter;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @contactUsSub.
  ///
  /// In en, this message translates to:
  /// **'Factory Location: Cairo, Egypt\nWhatsApp: +201151469761\nEmail: info@hadidiwin.com'**
  String get contactUsSub;

  /// No description provided for @contracted.
  ///
  /// In en, this message translates to:
  /// **'Contracted'**
  String get contracted;

  /// No description provided for @contractRequest.
  ///
  /// In en, this message translates to:
  /// **'Contract Request'**
  String get contractRequest;

  /// No description provided for @contractRequestDescription.
  ///
  /// In en, this message translates to:
  /// **'A contract request will be sent to the factory based on the selected items in the cart. Our team will review the request and contact you.'**
  String get contractRequestDescription;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'US'**
  String get countryCode;

  /// No description provided for @cutting.
  ///
  /// In en, this message translates to:
  /// **'Cutting'**
  String get cutting;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @debug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// No description provided for @debugModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get debugModeLabel;

  /// No description provided for @defaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultAddress;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteItemConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteItemConfirmation;

  /// No description provided for @deleteItemFromCartConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this item from your cart?'**
  String get deleteItemFromCartConfirmation;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @digitalWarranty.
  ///
  /// In en, this message translates to:
  /// **'Digital Warranty'**
  String get digitalWarranty;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @doneTimeline.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneTimeline;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @door.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get door;

  /// No description provided for @theType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get theType;

  /// No description provided for @doorType.
  ///
  /// In en, this message translates to:
  /// **'Door Type'**
  String get doorType;

  /// No description provided for @doubleWindow.
  ///
  /// In en, this message translates to:
  /// **'Double Window'**
  String get doubleWindow;

  /// No description provided for @duplicateItem.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Item'**
  String get duplicateItem;

  /// No description provided for @durabilityGuaranteed.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed durability for all UPVC profiles'**
  String get durabilityGuaranteed;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// No description provided for @energyEfficient.
  ///
  /// In en, this message translates to:
  /// **'Energy Efficient'**
  String get energyEfficient;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @error_address_emoji_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Emojis are not allowed in the address'**
  String get error_address_emoji_not_allowed;

  /// No description provided for @error_address_invalid_special_characters.
  ///
  /// In en, this message translates to:
  /// **'Address contains invalid special characters'**
  String get error_address_invalid_special_characters;

  /// No description provided for @error_address_label_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Address label can\'t be empty'**
  String get error_address_label_cant_be_empty;

  /// No description provided for @error_address_label_too_long.
  ///
  /// In en, this message translates to:
  /// **'Address label is too long, maximum 30 characters'**
  String get error_address_label_too_long;

  /// No description provided for @error_address_line_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Address can\'t be empty'**
  String get error_address_line_cant_be_empty;

  /// No description provided for @error_address_line_too_long.
  ///
  /// In en, this message translates to:
  /// **'Address is too long, maximum 100 characters'**
  String get error_address_line_too_long;

  /// No description provided for @error_arabic_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Arabic characters are not allowed'**
  String get error_arabic_not_allowed;

  /// No description provided for @error_city_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'City can\'t be empty'**
  String get error_city_cant_be_empty;

  /// No description provided for @error_city_invalid_special_characters.
  ///
  /// In en, this message translates to:
  /// **'City contains invalid special characters'**
  String get error_city_invalid_special_characters;

  /// No description provided for @error_city_too_long.
  ///
  /// In en, this message translates to:
  /// **'City name is too long, maximum 50 characters'**
  String get error_city_too_long;

  /// No description provided for @error_email_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Email can\'t be empty'**
  String get error_email_cant_be_empty;

  /// No description provided for @error_email_contains_invalid_characters.
  ///
  /// In en, this message translates to:
  /// **'Email contains invalid characters'**
  String get error_email_contains_invalid_characters;

  /// No description provided for @error_email_emoji_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Emojis are not allowed'**
  String get error_email_emoji_not_allowed;

  /// No description provided for @error_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get error_email_invalid;

  /// No description provided for @error_email_must_be_in_lowercase.
  ///
  /// In en, this message translates to:
  /// **'Email must be in lowercase'**
  String get error_email_must_be_in_lowercase;

  /// No description provided for @error_email_must_contain_at_symbol.
  ///
  /// In en, this message translates to:
  /// **'Email must contain \'@\''**
  String get error_email_must_contain_at_symbol;

  /// No description provided for @error_email_not_in_lower_case.
  ///
  /// In en, this message translates to:
  /// **'Email must be in lower case'**
  String get error_email_not_in_lower_case;

  /// No description provided for @error_email_not_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get error_email_not_invalid_format;

  /// No description provided for @error_name_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty'**
  String get error_name_cant_be_empty;

  /// No description provided for @error_phone_number_min_length.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 11 characters long'**
  String get error_phone_number_min_length;

  /// No description provided for @error_name_emoji_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Emojis are not allowed'**
  String get error_name_emoji_not_allowed;

  /// No description provided for @error_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid name format'**
  String get error_name_invalid;

  /// No description provided for @error_name_invalid_special_characters.
  ///
  /// In en, this message translates to:
  /// **'Name contains invalid special characters'**
  String get error_name_invalid_special_characters;

  /// No description provided for @error_name_too_long_maximum_20_characters.
  ///
  /// In en, this message translates to:
  /// **'Name is too long, maximum 20 characters'**
  String get error_name_too_long_maximum_20_characters;

  /// No description provided for @error_name_too_short_at_least_3_characters.
  ///
  /// In en, this message translates to:
  /// **'Name is too short, at least 3 characters'**
  String get error_name_too_short_at_least_3_characters;

  /// No description provided for @error_password_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get error_password_cant_be_empty;

  /// No description provided for @error_password_must_be_at_least_8_characters_long.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get error_password_must_be_at_least_8_characters_long;

  /// No description provided for @error_password_must_contain_uppercase_lowercase_number_and_special_character.
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase, number, and special character'**
  String
  get error_password_must_contain_uppercase_lowercase_number_and_special_character;

  /// No description provided for @error_phone_number_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Phone number can\'t be empty'**
  String get error_phone_number_cant_be_empty;

  /// No description provided for @error_phone_number_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get error_phone_number_invalid;

  /// No description provided for @estimatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get an instant, accurate quote for your windows & doors in simple steps.'**
  String get estimatorSubtitle;

  /// No description provided for @eta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get eta;

  /// No description provided for @exploreServices.
  ///
  /// In en, this message translates to:
  /// **'Explore Services'**
  String get exploreServices;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @finalTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get finalTotal;

  /// No description provided for @floorApt.
  ///
  /// In en, this message translates to:
  /// **'Floor / Apt'**
  String get floorApt;

  /// No description provided for @followUp.
  ///
  /// In en, this message translates to:
  /// **'Maintenance & Follow-up'**
  String get followUp;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @freeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get freeDelivery;

  /// No description provided for @freeDeliverySub.
  ///
  /// In en, this message translates to:
  /// **'Get it by tomorrow'**
  String get freeDeliverySub;

  /// No description provided for @freeReturns.
  ///
  /// In en, this message translates to:
  /// **'Free Returns'**
  String get freeReturns;

  /// No description provided for @freeReturnsSub.
  ///
  /// In en, this message translates to:
  /// **'Enjoy 15 days free return policy'**
  String get freeReturnsSub;

  /// No description provided for @freeShipping.
  ///
  /// In en, this message translates to:
  /// **'Free Shipping'**
  String get freeShipping;

  /// No description provided for @freeShippingSub.
  ///
  /// In en, this message translates to:
  /// **'On orders above 15,000 EGP'**
  String get freeShippingSub;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @getInstantEstimates.
  ///
  /// In en, this message translates to:
  /// **'Get instant estimates'**
  String get getInstantEstimates;

  /// No description provided for @glass.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get glass;

  /// No description provided for @glassClearSingle.
  ///
  /// In en, this message translates to:
  /// **'Clear Single'**
  String get glassClearSingle;

  /// No description provided for @glassDoubleGlass.
  ///
  /// In en, this message translates to:
  /// **'Double Glass'**
  String get glassDoubleGlass;

  /// No description provided for @glassFrost.
  ///
  /// In en, this message translates to:
  /// **'Frost'**
  String get glassFrost;

  /// No description provided for @glassNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get glassNone;

  /// No description provided for @glassReflective.
  ///
  /// In en, this message translates to:
  /// **'Reflective'**
  String get glassReflective;

  /// No description provided for @glassType.
  ///
  /// In en, this message translates to:
  /// **'Glass Type'**
  String get glassType;

  /// No description provided for @glassTypeOptional.
  ///
  /// In en, this message translates to:
  /// **'Glass Type (if any)'**
  String get glassTypeOptional;

  /// No description provided for @govAlexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get govAlexandria;

  /// No description provided for @govAssiut.
  ///
  /// In en, this message translates to:
  /// **'Assiut'**
  String get govAssiut;

  /// No description provided for @govAswan.
  ///
  /// In en, this message translates to:
  /// **'Aswan'**
  String get govAswan;

  /// No description provided for @govBeheira.
  ///
  /// In en, this message translates to:
  /// **'Beheira'**
  String get govBeheira;

  /// No description provided for @govBeniSuef.
  ///
  /// In en, this message translates to:
  /// **'Beni Suef'**
  String get govBeniSuef;

  /// No description provided for @govCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get govCairo;

  /// No description provided for @govDakahlia.
  ///
  /// In en, this message translates to:
  /// **'Dakahlia'**
  String get govDakahlia;

  /// No description provided for @govDamietta.
  ///
  /// In en, this message translates to:
  /// **'Damietta'**
  String get govDamietta;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @govFayoum.
  ///
  /// In en, this message translates to:
  /// **'Fayoum'**
  String get govFayoum;

  /// No description provided for @govGharbiya.
  ///
  /// In en, this message translates to:
  /// **'Gharbiya'**
  String get govGharbiya;

  /// No description provided for @govGiza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get govGiza;

  /// No description provided for @govIsmailia.
  ///
  /// In en, this message translates to:
  /// **'Ismailia'**
  String get govIsmailia;

  /// No description provided for @govKafrElSheikh.
  ///
  /// In en, this message translates to:
  /// **'Kafr El Sheikh'**
  String get govKafrElSheikh;

  /// No description provided for @govLuxor.
  ///
  /// In en, this message translates to:
  /// **'Luxor'**
  String get govLuxor;

  /// No description provided for @govMatrouh.
  ///
  /// In en, this message translates to:
  /// **'Matrouh'**
  String get govMatrouh;

  /// No description provided for @govMinya.
  ///
  /// In en, this message translates to:
  /// **'Minya'**
  String get govMinya;

  /// No description provided for @govMonufia.
  ///
  /// In en, this message translates to:
  /// **'Monufia'**
  String get govMonufia;

  /// No description provided for @govNewValley.
  ///
  /// In en, this message translates to:
  /// **'New Valley'**
  String get govNewValley;

  /// No description provided for @govNorthSinai.
  ///
  /// In en, this message translates to:
  /// **'North Sinai'**
  String get govNorthSinai;

  /// No description provided for @govPortSaid.
  ///
  /// In en, this message translates to:
  /// **'Port Said'**
  String get govPortSaid;

  /// No description provided for @govQalyubia.
  ///
  /// In en, this message translates to:
  /// **'Qalyubia'**
  String get govQalyubia;

  /// No description provided for @govQena.
  ///
  /// In en, this message translates to:
  /// **'Qena'**
  String get govQena;

  /// No description provided for @govRedSea.
  ///
  /// In en, this message translates to:
  /// **'Red Sea'**
  String get govRedSea;

  /// No description provided for @govSharqia.
  ///
  /// In en, this message translates to:
  /// **'Sharqia'**
  String get govSharqia;

  /// No description provided for @govSohag.
  ///
  /// In en, this message translates to:
  /// **'Sohag'**
  String get govSohag;

  /// No description provided for @govSouthSinai.
  ///
  /// In en, this message translates to:
  /// **'South Sinai'**
  String get govSouthSinai;

  /// No description provided for @govSuez.
  ///
  /// In en, this message translates to:
  /// **'Suez'**
  String get govSuez;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get height;

  /// No description provided for @hinged.
  ///
  /// In en, this message translates to:
  /// **'Hinged'**
  String get hinged;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @howCanWeHelpSub.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help! Choose a contact method below to reach our support team.'**
  String get howCanWeHelpSub;

  /// No description provided for @howHandleData.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get howHandleData;

  /// No description provided for @incompleteData.
  ///
  /// In en, this message translates to:
  /// **'Needs data completion'**
  String get incompleteData;

  /// No description provided for @incompleteItemsWarning.
  ///
  /// In en, this message translates to:
  /// **'{count} {label} incomplete — won\'t be added to cart'**
  String incompleteItemsWarning(String count, String label);

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @innovation.
  ///
  /// In en, this message translates to:
  /// **'Innovation'**
  String get innovation;

  /// No description provided for @innovationSub.
  ///
  /// In en, this message translates to:
  /// **'By integrating smart pricing and real-time product previews, we empower our clients to design their dream spaces with precision and transparency.'**
  String get innovationSub;

  /// No description provided for @inProduction.
  ///
  /// In en, this message translates to:
  /// **'In Production'**
  String get inProduction;

  /// No description provided for @inProductionSub.
  ///
  /// In en, this message translates to:
  /// **'Crafting and assembling your profiles'**
  String get inProductionSub;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @inProgressTimeline.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgressTimeline;

  /// No description provided for @inquireDesign.
  ///
  /// In en, this message translates to:
  /// **'Inquire About This Design'**
  String get inquireDesign;

  /// No description provided for @insectScreen.
  ///
  /// In en, this message translates to:
  /// **'Insect Screen'**
  String get insectScreen;

  /// No description provided for @inspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get inspection;

  /// No description provided for @installation.
  ///
  /// In en, this message translates to:
  /// **'Installation'**
  String get installation;

  /// No description provided for @installationSub.
  ///
  /// In en, this message translates to:
  /// **'Final delivery and fitting at location'**
  String get installationSub;

  /// No description provided for @installDate.
  ///
  /// In en, this message translates to:
  /// **'Install Date'**
  String get installDate;

  /// No description provided for @installerStore.
  ///
  /// In en, this message translates to:
  /// **'Installer Store'**
  String get installerStore;

  /// No description provided for @installInfo.
  ///
  /// In en, this message translates to:
  /// **'Install Info'**
  String get installInfo;

  /// No description provided for @instantPrices.
  ///
  /// In en, this message translates to:
  /// **'Instant Prices'**
  String get instantPrices;

  /// No description provided for @internetConnectionRestored.
  ///
  /// In en, this message translates to:
  /// **'Internet connection restored'**
  String get internetConnectionRestored;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Invalid name'**
  String get invalidName;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @isRoundedLabel.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get isRoundedLabel;

  /// No description provided for @itemLabel.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get itemLabel;

  /// No description provided for @itemNumber.
  ///
  /// In en, this message translates to:
  /// **'Item #{index}'**
  String itemNumber(String index);

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get itemsLabel;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English (US)'**
  String get languageSubtitle;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @limitedTime.
  ///
  /// In en, this message translates to:
  /// **'LIMITED TIME'**
  String get limitedTime;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNow;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logoutDescription;

  /// No description provided for @mainDoor.
  ///
  /// In en, this message translates to:
  /// **'Main Door'**
  String get mainDoor;

  /// No description provided for @maintenanceRequest.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Request'**
  String get maintenanceRequest;

  /// No description provided for @manageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage alerts and updates'**
  String get manageAlerts;

  /// No description provided for @manageProfile.
  ///
  /// In en, this message translates to:
  /// **'Manage Profile'**
  String get manageProfile;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @meetTeam.
  ///
  /// In en, this message translates to:
  /// **'Meet the engineering team'**
  String get meetTeam;

  /// No description provided for @missing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get missing;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @myServices.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get myServices;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navEstimator.
  ///
  /// In en, this message translates to:
  /// **'Estimator'**
  String get navEstimator;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navProducts;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get needHelp;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @noAddressesRegistered.
  ///
  /// In en, this message translates to:
  /// **'No registered addresses. Please add a shipping address first.'**
  String get noAddressesRegistered;

  /// No description provided for @noBrandsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No brands available for this type'**
  String get noBrandsAvailable;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @noDataFoundSub.
  ///
  /// In en, this message translates to:
  /// **'There is no data to display right now.'**
  String get noDataFoundSub;

  /// No description provided for @noGlassOptions.
  ///
  /// In en, this message translates to:
  /// **'No glass options available'**
  String get noGlassOptions;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @noItemsInEstimate.
  ///
  /// In en, this message translates to:
  /// **'No items in estimate'**
  String get noItemsInEstimate;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @noNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay tuned! Your notifications will appear here.'**
  String get noNotificationsDescription;

  /// No description provided for @noOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get noOptionsAvailable;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @noOrdersSub.
  ///
  /// In en, this message translates to:
  /// **'Your placed orders will appear here for tracking.'**
  String get noOrdersSub;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable push notifications'**
  String get pushNotificationsSubtitle;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @noTypesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No types available for this brand'**
  String get noTypesAvailable;

  /// No description provided for @nowTimeline.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get nowTimeline;

  /// No description provided for @occasion.
  ///
  /// In en, this message translates to:
  /// **'Occasion'**
  String get occasion;

  /// No description provided for @offer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get offer;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @onboardingSub1.
  ///
  /// In en, this message translates to:
  /// **'With you from the first order to after-sales service'**
  String get onboardingSub1;

  /// No description provided for @onboardingSub2.
  ///
  /// In en, this message translates to:
  /// **'We provide accurate and detailed quotes in no time'**
  String get onboardingSub2;

  /// No description provided for @onboardingSub3.
  ///
  /// In en, this message translates to:
  /// **'We guarantee the best materials and long-lasting finishes'**
  String get onboardingSub3;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Excellence You Can Trust'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Fast & Professional Pricing'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'High Quality & Efficiency'**
  String get onboardingTitle3;

  /// No description provided for @operatingEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Operating Environment'**
  String get operatingEnvironment;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get orderConfirmed;

  /// No description provided for @orderConfirmedSub.
  ///
  /// In en, this message translates to:
  /// **'Deposit received & order processed'**
  String get orderConfirmedSub;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @orderPlacedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get orderPlacedSuccessfully;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get orderStatus;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @orderUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order Update'**
  String get orderUpdate;

  /// No description provided for @osLabel.
  ///
  /// In en, this message translates to:
  /// **'OS'**
  String get osLabel;

  /// No description provided for @osVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'OS Version'**
  String get osVersionLabel;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We have sent the code to your phone'**
  String get otpSentTo;

  /// No description provided for @ourHeritage.
  ///
  /// In en, this message translates to:
  /// **'Our Heritage'**
  String get ourHeritage;

  /// No description provided for @ourHeritageSub.
  ///
  /// In en, this message translates to:
  /// **'Hadidi Win is a leading Egyptian factory specializing in premium U-UPVC windows and doors. With decades of expertise in the construction sector, we bring European standards to the Egyptian market.'**
  String get ourHeritageSub;

  /// No description provided for @ourPrices.
  ///
  /// In en, this message translates to:
  /// **'Our Prices'**
  String get ourPrices;

  /// No description provided for @ourWork.
  ///
  /// In en, this message translates to:
  /// **'Our Work'**
  String get ourWork;

  /// No description provided for @packageNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageNameLabel;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get passwordConfirmation;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @pendingTimeline.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingTimeline;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone Number or Email'**
  String get phoneNumberOrEmail;

  /// No description provided for @pleaseSelectShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Please select a shipping address'**
  String get pleaseSelectShippingAddress;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @precisionCrafted.
  ///
  /// In en, this message translates to:
  /// **'Crafted with precision and global standards'**
  String get precisionCrafted;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @premiumUPVC.
  ///
  /// In en, this message translates to:
  /// **'Premium UPVC'**
  String get premiumUPVC;

  /// No description provided for @preparation.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get preparation;

  /// No description provided for @preparingProducts.
  ///
  /// In en, this message translates to:
  /// **'Preparing products and prices list\nWait a moment'**
  String get preparingProducts;

  /// No description provided for @pricePerMeter.
  ///
  /// In en, this message translates to:
  /// **'Price per meter:'**
  String get pricePerMeter;

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @productCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productCategory;

  /// No description provided for @productColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get productColor;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @productDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get productDimensions;

  /// No description provided for @productInStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get productInStock;

  /// No description provided for @productionTimeline.
  ///
  /// In en, this message translates to:
  /// **'Production Timeline'**
  String get productionTimeline;

  /// No description provided for @productItem.
  ///
  /// In en, this message translates to:
  /// **'Product Item {index}'**
  String productItem(String index);

  /// No description provided for @productOverview.
  ///
  /// In en, this message translates to:
  /// **'Product Overview'**
  String get productOverview;

  /// No description provided for @productSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search windows, doors, accessories...'**
  String get productSearchHint;

  /// No description provided for @productSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get productSize;

  /// No description provided for @productSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get productSpecifications;

  /// No description provided for @productWarranty.
  ///
  /// In en, this message translates to:
  /// **'1 Year Warranty'**
  String get productWarranty;

  /// No description provided for @productWarrantySub.
  ///
  /// In en, this message translates to:
  /// **'Authentic product with official warranty'**
  String get productWarrantySub;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @project1Desc.
  ///
  /// In en, this message translates to:
  /// **'Full UPVC window installation for a modern villa in New Cairo.'**
  String get project1Desc;

  /// No description provided for @project1Loc.
  ///
  /// In en, this message translates to:
  /// **'New Cairo, Egypt'**
  String get project1Loc;

  /// No description provided for @project1Title.
  ///
  /// In en, this message translates to:
  /// **'Modern Villa Windows'**
  String get project1Title;

  /// No description provided for @project2Desc.
  ///
  /// In en, this message translates to:
  /// **'Heavy-duty UPVC doors for a commercial complex.'**
  String get project2Desc;

  /// No description provided for @project2Loc.
  ///
  /// In en, this message translates to:
  /// **'6th of October City'**
  String get project2Loc;

  /// No description provided for @project2Title.
  ///
  /// In en, this message translates to:
  /// **'Office Complex Doors'**
  String get project2Title;

  /// No description provided for @project3Desc.
  ///
  /// In en, this message translates to:
  /// **'Sliding systems for balcony doors.'**
  String get project3Desc;

  /// No description provided for @project3Loc.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get project3Loc;

  /// No description provided for @project3Title.
  ///
  /// In en, this message translates to:
  /// **'Residential Balcony Systems'**
  String get project3Title;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project Description'**
  String get projectDescription;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @promotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotion;

  /// No description provided for @qc.
  ///
  /// In en, this message translates to:
  /// **'Quality Check'**
  String get qc;

  /// No description provided for @qualityCheck.
  ///
  /// In en, this message translates to:
  /// **'Quality Check'**
  String get qualityCheck;

  /// No description provided for @qualityCheckSub.
  ///
  /// In en, this message translates to:
  /// **'Inspecting finish and hardware'**
  String get qualityCheckSub;

  /// No description provided for @qualityFirst.
  ///
  /// In en, this message translates to:
  /// **'Quality First'**
  String get qualityFirst;

  /// No description provided for @qualityFirstSub.
  ///
  /// In en, this message translates to:
  /// **'We use high-grade profiles designed to withstand Egypt\'s unique climate. Our products offer superior thermal insulation, soundproofing, and are resistant to dust and wind.'**
  String get qualityFirstSub;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready for Delivery'**
  String get ready;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @recentProjects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get recentProjects;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @release.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get release;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @removeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removeAPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @requestMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Request Maintenance'**
  String get requestMaintenance;

  /// No description provided for @requestQuote.
  ///
  /// In en, this message translates to:
  /// **'Request Official Quote'**
  String get requestQuote;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @savedItems.
  ///
  /// In en, this message translates to:
  /// **'Your saved items'**
  String get savedItems;

  /// No description provided for @saveElectricity.
  ///
  /// In en, this message translates to:
  /// **'Save up to 30% on your electricity bills'**
  String get saveElectricity;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @sectorPrices.
  ///
  /// In en, this message translates to:
  /// **'Sector Prices'**
  String get sectorPrices;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @selectShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Select Shipping Address'**
  String get selectShippingAddress;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredDescription.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again to continue.'**
  String get sessionExpiredDescription;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddress;

  /// No description provided for @shoppingOrders.
  ///
  /// In en, this message translates to:
  /// **'Shopping & Orders'**
  String get shoppingOrders;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @singleWindow.
  ///
  /// In en, this message translates to:
  /// **'Single Window'**
  String get singleWindow;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @sliding.
  ///
  /// In en, this message translates to:
  /// **'Sliding'**
  String get sliding;

  /// No description provided for @slidingDoor.
  ///
  /// In en, this message translates to:
  /// **'Sliding Door'**
  String get slidingDoor;

  /// No description provided for @smartAiEstimator.
  ///
  /// In en, this message translates to:
  /// **'Estimator'**
  String get smartAiEstimator;

  /// No description provided for @smartPricing.
  ///
  /// In en, this message translates to:
  /// **'Smart Pricing'**
  String get smartPricing;

  /// No description provided for @soundInsulationTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Insulation'**
  String get soundInsulationTitle;

  /// No description provided for @soundProofing.
  ///
  /// In en, this message translates to:
  /// **'Premium Quality'**
  String get soundProofing;

  /// No description provided for @soundSub.
  ///
  /// In en, this message translates to:
  /// **'European standards U-UPVC for maximum durability.'**
  String get soundSub;

  /// No description provided for @streetName.
  ///
  /// In en, this message translates to:
  /// **'Street Name'**
  String get streetName;

  /// No description provided for @submitTicket.
  ///
  /// In en, this message translates to:
  /// **'Submit a service ticket'**
  String get submitTicket;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get support;

  /// No description provided for @supportHelp.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportHelp;

  /// No description provided for @swing.
  ///
  /// In en, this message translates to:
  /// **'Swing'**
  String get swing;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @technicalSurvey.
  ///
  /// In en, this message translates to:
  /// **'Technical Survey'**
  String get technicalSurvey;

  /// No description provided for @technicalSurveySub.
  ///
  /// In en, this message translates to:
  /// **'Engineer took final measurements'**
  String get technicalSurveySub;

  /// No description provided for @tenYearWarranty.
  ///
  /// In en, this message translates to:
  /// **'10-Year Warranty'**
  String get tenYearWarranty;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @thermalInsulation.
  ///
  /// In en, this message translates to:
  /// **'Smart Pricing'**
  String get thermalInsulation;

  /// No description provided for @thermalSub.
  ///
  /// In en, this message translates to:
  /// **'Transparent & competitive pricing for every budget.'**
  String get thermalSub;

  /// No description provided for @tilt.
  ///
  /// In en, this message translates to:
  /// **'Tilt'**
  String get tilt;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalEstimate.
  ///
  /// In en, this message translates to:
  /// **'Total Estimate:'**
  String get totalEstimate;

  /// No description provided for @totalItemsCount.
  ///
  /// In en, this message translates to:
  /// **'Total ({count} items)'**
  String totalItemsCount(String count);

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get totalPrice;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @trackReturnBuy.
  ///
  /// In en, this message translates to:
  /// **'Track, return, or buy again'**
  String get trackReturnBuy;

  /// No description provided for @trackStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your tracking ID to see the real-time progress of your premium UPVC units.'**
  String get trackStatusSubtitle;

  /// No description provided for @trackStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Track your order status'**
  String get trackStatusTitle;

  /// No description provided for @tryChangingCategoryOrSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try changing your search term or category'**
  String get tryChangingCategoryOrSearchTerm;

  /// No description provided for @turkishTech.
  ///
  /// In en, this message translates to:
  /// **'Turkish Technology'**
  String get turkishTech;

  /// No description provided for @orContactUsVia.
  ///
  /// In en, this message translates to:
  /// **'Or contact us via'**
  String get orContactUsVia;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @typeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get typeFixed;

  /// No description provided for @typeHinged.
  ///
  /// In en, this message translates to:
  /// **'Hinged'**
  String get typeHinged;

  /// No description provided for @typePlisse.
  ///
  /// In en, this message translates to:
  /// **'Plisse'**
  String get typePlisse;

  /// No description provided for @typeSliding.
  ///
  /// In en, this message translates to:
  /// **'Sliding'**
  String get typeSliding;

  /// No description provided for @typeSwing.
  ///
  /// In en, this message translates to:
  /// **'Swing'**
  String get typeSwing;

  /// No description provided for @typeTilt.
  ///
  /// In en, this message translates to:
  /// **'Tilt'**
  String get typeTilt;

  /// No description provided for @whatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get whatsappNumber;

  /// No description provided for @typeWood.
  ///
  /// In en, this message translates to:
  /// **'Wood finish'**
  String get typeWood;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get unit;

  /// No description provided for @unitRef.
  ///
  /// In en, this message translates to:
  /// **'Unit Ref'**
  String get unitRef;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddress;

  /// No description provided for @updateDate.
  ///
  /// In en, this message translates to:
  /// **'Update Date'**
  String get updateDate;

  /// No description provided for @usageRules.
  ///
  /// In en, this message translates to:
  /// **'App usage rules and agreements'**
  String get usageRules;

  /// No description provided for @youCannotEditProfileWhileOffline.
  ///
  /// In en, this message translates to:
  /// **'You cannot edit your profile while offline. Please check your internet connection and try again.'**
  String get youCannotEditProfileWhileOffline;

  /// No description provided for @valuedClient.
  ///
  /// In en, this message translates to:
  /// **'Valued Client'**
  String get valuedClient;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @viewCurrentRates.
  ///
  /// In en, this message translates to:
  /// **'View current rates per meter'**
  String get viewCurrentRates;

  /// No description provided for @viewInstallations.
  ///
  /// In en, this message translates to:
  /// **'View installations'**
  String get viewInstallations;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @warrantyExpiry.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String warrantyExpiry(String date);

  /// No description provided for @weatherResistant.
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery'**
  String get weatherResistant;

  /// No description provided for @weatherSub.
  ///
  /// In en, this message translates to:
  /// **'We respect your time with precise delivery dates.'**
  String get weatherSub;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'High-quality windows & doors crafted for your comfort.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium UPVC Solutions'**
  String get welcomeTitle;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Support'**
  String get whatsapp;

  /// No description provided for @whyHadidiWin.
  ///
  /// In en, this message translates to:
  /// **'Why Hadidi Win?'**
  String get whyHadidiWin;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width (cm)'**
  String get width;

  /// No description provided for @window.
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get window;

  /// No description provided for @windowType.
  ///
  /// In en, this message translates to:
  /// **'Window Type'**
  String get windowType;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmpty;

  /// No description provided for @wishlistEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Save items you like to see them here later.'**
  String get wishlistEmptySub;

  /// No description provided for @woodFinish.
  ///
  /// In en, this message translates to:
  /// **'Wood finish'**
  String get woodFinish;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yourSelection.
  ///
  /// In en, this message translates to:
  /// **'Your Selection'**
  String get yourSelection;

  /// No description provided for @contactUsViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Contact us via WhatsApp'**
  String get contactUsViaWhatsapp;

  /// No description provided for @whatsappSupportSubTitle.
  ///
  /// In en, this message translates to:
  /// **'We are here to help you and answer all your inquiries anytime'**
  String get whatsappSupportSubTitle;

  /// No description provided for @messageNow.
  ///
  /// In en, this message translates to:
  /// **'Message Now'**
  String get messageNow;

  /// No description provided for @youCannotManageAddressesWhileOffline.
  ///
  /// In en, this message translates to:
  /// **'You cannot manage addresses without an internet connection'**
  String get youCannotManageAddressesWhileOffline;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get rounded;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @changeLanguageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change the language?'**
  String get changeLanguageConfirm;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @openFile.
  ///
  /// In en, this message translates to:
  /// **'Open File'**
  String get openFile;

  /// No description provided for @downloadFile.
  ///
  /// In en, this message translates to:
  /// **'Download File'**
  String get downloadFile;

  /// No description provided for @fileSavedToDcim.
  ///
  /// In en, this message translates to:
  /// **'Your file has been saved to DCIM/HadidiWin folder\nFile name is {fileName}'**
  String fileSavedToDcim(Object fileName);

  /// No description provided for @fileSavedToDocuments.
  ///
  /// In en, this message translates to:
  /// **'Your file has been saved to Documents/HadidiWin folder\nFile name is {fileName}'**
  String fileSavedToDocuments(Object fileName);

  /// No description provided for @fileAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'This attachment has already been saved'**
  String get fileAlreadySaved;

  /// No description provided for @dimensionInspectionNote.
  ///
  /// In en, this message translates to:
  /// **'This product\'s dimensions range between {width} (width) and {height} (height). The exact size will be determined during site measurement.'**
  String dimensionInspectionNote(Object height, Object width);

  /// No description provided for @whatsappNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Communication via WhatsApp is currently unavailable, please try again later'**
  String get whatsappNotAvailable;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentReceived;

  /// No description provided for @invoiceIssued.
  ///
  /// In en, this message translates to:
  /// **'Invoice Issued'**
  String get invoiceIssued;

  /// No description provided for @orderStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Order Status Changed'**
  String get orderStatusChanged;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password has been reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @notificationDateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationDateToday;

  /// No description provided for @notificationDateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationDateYesterday;

  /// No description provided for @notificationDateThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get notificationDateThisWeek;

  /// No description provided for @notificationDateEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationDateEarlier;

  /// No description provided for @youHaveNewNotificationsPrefix.
  ///
  /// In en, this message translates to:
  /// **'You have '**
  String get youHaveNewNotificationsPrefix;

  /// No description provided for @youHaveNewNotificationsSuffix.
  ///
  /// In en, this message translates to:
  /// **' new notifications'**
  String get youHaveNewNotificationsSuffix;

  /// No description provided for @httpNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get httpNoInternet;

  /// No description provided for @httpSendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out while sending data. Please try again.'**
  String get httpSendTimeout;

  /// No description provided for @httpRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled.'**
  String get httpRequestCancelled;

  /// No description provided for @httpBadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Secure connection failed. Please contact support.'**
  String get httpBadCertificate;

  /// No description provided for @httpBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request. Please check your input.'**
  String get httpBadRequest;

  /// No description provided for @httpUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get httpUnauthorized;

  /// No description provided for @httpForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to perform this action.'**
  String get httpForbidden;

  /// No description provided for @httpNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get httpNotFound;

  /// No description provided for @httpRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond.'**
  String get httpRequestTimeout;

  /// No description provided for @httpConflict.
  ///
  /// In en, this message translates to:
  /// **'This request conflicts with the current state.'**
  String get httpConflict;

  /// No description provided for @httpUnprocessableEntity.
  ///
  /// In en, this message translates to:
  /// **'The submitted data is invalid. Please review and try again.'**
  String get httpUnprocessableEntity;

  /// No description provided for @httpTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please slow down and try again shortly.'**
  String get httpTooManyRequests;

  /// No description provided for @httpInternalServerError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get httpInternalServerError;

  /// No description provided for @httpBadGateway.
  ///
  /// In en, this message translates to:
  /// **'The server received an invalid response. Please try again.'**
  String get httpBadGateway;

  /// No description provided for @httpServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service is temporarily unavailable. Please try again later.'**
  String get httpServiceUnavailable;

  /// No description provided for @httpGatewayTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long to respond. Please try again.'**
  String get httpGatewayTimeout;

  /// No description provided for @httpUnknownError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get httpUnknownError;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Please update to continue using the app.'**
  String get updateRequiredMessage;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'We are currently undergoing maintenance. Please check back later.'**
  String get maintenanceMessage;

  /// No description provided for @myInvoices.
  ///
  /// In en, this message translates to:
  /// **'My Invoices'**
  String get myInvoices;

  /// No description provided for @viewInvoices.
  ///
  /// In en, this message translates to:
  /// **'View purchase invoices'**
  String get viewInvoices;

  /// No description provided for @invoiceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetailsTitle;

  /// No description provided for @invoicePrefix.
  ///
  /// In en, this message translates to:
  /// **'Invoice #'**
  String get invoicePrefix;

  /// No description provided for @orderPrefix.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get orderPrefix;

  /// No description provided for @invoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Invoice Date'**
  String get invoiceDate;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @amountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amountPaid;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalance;

  /// No description provided for @discountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountAmount;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @transactionRef.
  ///
  /// In en, this message translates to:
  /// **'Transaction Ref'**
  String get transactionRef;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @partial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get partial;

  /// No description provided for @noInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices'**
  String get noInvoices;

  /// No description provided for @noInvoicesSub.
  ///
  /// In en, this message translates to:
  /// **'Your issued invoices will appear here for review.'**
  String get noInvoicesSub;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
