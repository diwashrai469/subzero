import 'package:flutter/material.dart';
import 'package:subzero/common/constant/app_image.dart';
import 'package:subzero/feature/add_subscription/model/subscription_category_model.dart';

const Color bgColor = Color(0xFFF6F7F9);
const Color cardColor = Colors.white;
const Color inputColor = Color(0xFFF9FAFB);
const Color textPrimary = Color(0xFF111827);
const Color textSecondary = Color(0xFF6B7280);
const Color borderColor = Color(0xFFE5E7EB);

const cycles = [
  'Weekly',
  'Fortnightly',
  'Monthly',
  'Quarterly',
  'Semi-annually',
  'Yearly',
];

const categoriesList = <SubscriptionCategoryModel>[
  SubscriptionCategoryModel(
    label: 'Netflix',
    emoji: AppImage.netflix,
    iconColor: Color(0xFFE50914),
    bgColor: Color(0xFFFFE8EA),
  ),
  SubscriptionCategoryModel(
    label: 'YouTube',
    emoji: AppImage.youtube,
    iconColor: Color(0xFFFF0000),
    bgColor: Color(0xFFFFE8E8),
  ),
  SubscriptionCategoryModel(
    label: 'Spotify',
    emoji: AppImage.spotify,
    iconColor: Color(0xFF1DB954),
    bgColor: Color(0xFFE8F5E9),
  ),
  SubscriptionCategoryModel(
    label: 'Rent',
    emoji: AppImage.rent,
    iconColor: Color(0xFF4CAF50),
    bgColor: Color(0xFFE8F5E9),
  ),
  SubscriptionCategoryModel(
    label: 'Internet',
    emoji: AppImage.internet,
    iconColor: Color(0xFF2196F3),
    bgColor: Color(0xFFE3F2FD),
  ),
  SubscriptionCategoryModel(
    label: 'Car Loan',
    emoji: AppImage.carLoan,
    iconColor: Color(0xFFE67E22),
    bgColor: Color(0xFFFFF0E0),
  ),
  SubscriptionCategoryModel(
    label: 'Mobile Plan',
    emoji: AppImage.mobilePlan,
    iconColor: Color(0xFF1ABC9C),
    bgColor: Color(0xFFE0F7F4),
  ),
  SubscriptionCategoryModel(
    label: 'Insurance',
    emoji: AppImage.insurance,
    iconColor: Color(0xFFE91E63),
    bgColor: Color(0xFFFFE8F3),
  ),
  SubscriptionCategoryModel(
    label: 'Gym',
    emoji: AppImage.gym,
    iconColor: Color(0xFF2ECC71),
    bgColor: Color(0xFFE8F8F0),
  ),

  SubscriptionCategoryModel(
    label: 'Cloud',
    emoji: AppImage.cloudServer,
    iconColor: Color(0xFF2196F3),
    bgColor: Color(0xFFE3F2FD),
  ),
  SubscriptionCategoryModel(
    label: 'Electricity',
    emoji: AppImage.electricity,
    iconColor: Color(0xFFF1C40F),
    bgColor: Color(0xFFFFF9E6),
  ),
  SubscriptionCategoryModel(
    label: 'Education',
    emoji: AppImage.education,
    iconColor: Color(0xFF7C3AED),
    bgColor: Color(0xFFEDE9FE),
  ),
  SubscriptionCategoryModel(
    label: 'Finance',
    emoji: AppImage.finance,
    iconColor: Color(0xFF1ABC9C),
    bgColor: Color(0xFFE0F7F4),
  ),
  SubscriptionCategoryModel(
    label: 'Food',
    emoji: AppImage.food,
    iconColor: Color(0xFFE67E22),
    bgColor: Color(0xFFFFF0E0),
  ),
  SubscriptionCategoryModel(
    label: 'Gaming',
    emoji: AppImage.gaming,
    iconColor: Color(0xFFE74C3C),
    bgColor: Color(0xFFFFE8E8),
  ),
  SubscriptionCategoryModel(
    label: 'Gas',
    emoji: AppImage.gas,
    iconColor: Color(0xFFE74C3C),
    bgColor: Color(0xFFFFE8E8),
  ),

  SubscriptionCategoryModel(
    label: 'News',
    emoji: AppImage.news,
    iconColor: Color(0xFFF39C12),
    bgColor: Color(0xFFFFF3E0),
  ),

  SubscriptionCategoryModel(
    label: 'Productivity',
    emoji: AppImage.productivity,
    iconColor: Color(0xFF1565C0),
    bgColor: Color(0xFFE8EEF9),
  ),

  SubscriptionCategoryModel(
    label: 'Shopping',
    emoji: AppImage.shopping,
    iconColor: Color(0xFFE74C3C),
    bgColor: Color(0xFFFFE8EA),
  ),

  SubscriptionCategoryModel(
    label: 'Others',
    emoji: AppImage.others,
    iconColor: Color(0xFF607D8B),
    bgColor: Color(0xFFECEFF1),
  ),
];
