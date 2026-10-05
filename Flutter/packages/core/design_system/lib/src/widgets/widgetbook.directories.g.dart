// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:design_system/src/widgets/buttons/elevated_button/elevated_button_use_case.dart'
    as _design_system_src_widgets_buttons_elevated_button_elevated_button_use_case;
import 'package:design_system/src/widgets/buttons/filled_button/filled_button_use_case.dart'
    as _design_system_src_widgets_buttons_filled_button_filled_button_use_case;
import 'package:design_system/src/widgets/buttons/filled_tonal_button/filled_tonal_button_use_case.dart'
    as _design_system_src_widgets_buttons_filled_tonal_button_filled_tonal_button_use_case;
import 'package:design_system/src/widgets/buttons/icon_button/icon_button_use_case.dart'
    as _design_system_src_widgets_buttons_icon_button_icon_button_use_case;
import 'package:design_system/src/widgets/buttons/outlined_button/outlined_button_use_case.dart'
    as _design_system_src_widgets_buttons_outlined_button_outlined_button_use_case;
import 'package:design_system/src/widgets/buttons/text_button/text_button_use_case.dart'
    as _design_system_src_widgets_buttons_text_button_text_button_use_case;
import 'package:design_system/src/widgets/display/empty_state_use_case.dart'
    as _design_system_src_widgets_display_empty_state_use_case;
import 'package:design_system/src/widgets/display/error_state_use_case.dart'
    as _design_system_src_widgets_display_error_state_use_case;
import 'package:design_system/src/widgets/display/retryable_error_state_use_case.dart'
    as _design_system_src_widgets_display_retryable_error_state_use_case;
import 'package:design_system/src/widgets/display/section_header/section_header_use_case.dart'
    as _design_system_src_widgets_display_section_header_section_header_use_case;
import 'package:design_system/src/widgets/feedback/loading_indicator/loading_indicator_use_case.dart'
    as _design_system_src_widgets_feedback_loading_indicator_loading_indicator_use_case;
import 'package:design_system/src/widgets/feedback/shimmer/shimmer_use_case.dart'
    as _design_system_src_widgets_feedback_shimmer_shimmer_use_case;
import 'package:design_system/src/widgets/inputs/checkbox/checkbox_use_case.dart'
    as _design_system_src_widgets_inputs_checkbox_checkbox_use_case;
import 'package:design_system/src/widgets/inputs/switch/switch_use_case.dart'
    as _design_system_src_widgets_inputs_switch_switch_use_case;
import 'package:design_system/src/widgets/inputs/text_form_field/text_form_field_use_case.dart'
    as _design_system_src_widgets_inputs_text_form_field_text_form_field_use_case;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'core',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'widgets',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'buttons',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'elevated_button',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'ElevatedButtonComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_buttons_elevated_button_elevated_button_use_case
                                .buildElevatedButtonUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Icon',
                        builder:
                            _design_system_src_widgets_buttons_elevated_button_elevated_button_use_case
                                .buildElevatedButtonIconUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'filled_button',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'FilledButtonComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_buttons_filled_button_filled_button_use_case
                                .buildFilledButtonUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Disabled',
                        builder:
                            _design_system_src_widgets_buttons_filled_button_filled_button_use_case
                                .buildFilledButtonDisabledUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Icon',
                        builder:
                            _design_system_src_widgets_buttons_filled_button_filled_button_use_case
                                .buildFilledButtonIconUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'filled_tonal_button',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'FilledTonalButtonComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_buttons_filled_tonal_button_filled_tonal_button_use_case
                                .buildFilledTonalButtonUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Icon',
                        builder:
                            _design_system_src_widgets_buttons_filled_tonal_button_filled_tonal_button_use_case
                                .buildFilledTonalButtonIconUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'icon_button',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'IconButtonComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Filled',
                        builder:
                            _design_system_src_widgets_buttons_icon_button_icon_button_use_case
                                .buildIconButtonFilledUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Outlined',
                        builder:
                            _design_system_src_widgets_buttons_icon_button_icon_button_use_case
                                .buildIconButtonOutlinedUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Standard',
                        builder:
                            _design_system_src_widgets_buttons_icon_button_icon_button_use_case
                                .buildIconButtonStandardUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Tonal',
                        builder:
                            _design_system_src_widgets_buttons_icon_button_icon_button_use_case
                                .buildIconButtonTonalUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'outlined_button',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'OutlinedButtonComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_buttons_outlined_button_outlined_button_use_case
                                .buildOutlinedButtonUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Disabled',
                        builder:
                            _design_system_src_widgets_buttons_outlined_button_outlined_button_use_case
                                .buildOutlinedButtonDisabledUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'text_button',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'TextButtonComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_buttons_text_button_text_button_use_case
                                .buildTextButtonUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Icon',
                        builder:
                            _design_system_src_widgets_buttons_text_button_text_button_use_case
                                .buildTextButtonIconUseCase,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'display',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'EmptyStateWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _design_system_src_widgets_display_empty_state_use_case
                            .buildEmptyStateUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Long Text Overflow',
                    builder:
                        _design_system_src_widgets_display_empty_state_use_case
                            .buildEmptyStateLongTextUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Without Subtitle',
                    builder:
                        _design_system_src_widgets_display_empty_state_use_case
                            .buildEmptyStateNoSubtitleUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ErrorStateWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _design_system_src_widgets_display_error_state_use_case
                            .buildErrorStateUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Network Error',
                    builder:
                        _design_system_src_widgets_display_error_state_use_case
                            .buildErrorStateNetworkUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'RetryableErrorStateWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _design_system_src_widgets_display_retryable_error_state_use_case
                            .buildRetryableErrorStateUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Server Error',
                    builder:
                        _design_system_src_widgets_display_retryable_error_state_use_case
                            .buildRetryableErrorServerUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'section_header',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'SectionHeaderComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_display_section_header_section_header_use_case
                                .buildSectionHeaderUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Without Action',
                        builder:
                            _design_system_src_widgets_display_section_header_section_header_use_case
                                .buildSectionHeaderNoActionUseCase,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'feedback',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'loading_indicator',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'LoadingIndicatorComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Determinate',
                        builder:
                            _design_system_src_widgets_feedback_loading_indicator_loading_indicator_use_case
                                .buildLoadingIndicatorDeterminateUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Indeterminate',
                        builder:
                            _design_system_src_widgets_feedback_loading_indicator_loading_indicator_use_case
                                .buildLoadingIndicatorUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'shimmer',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'ShimmerComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_feedback_shimmer_shimmer_use_case
                                .buildShimmerUseCase,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'inputs',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'checkbox',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'CheckboxComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_inputs_checkbox_checkbox_use_case
                                .buildCheckboxUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'switch',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'SwitchComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_inputs_switch_switch_use_case
                                .buildSwitchUseCase,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'text_form_field',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'TextFormFieldComponent',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _design_system_src_widgets_inputs_text_form_field_text_form_field_use_case
                                .buildTextFormFieldUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Error',
                        builder:
                            _design_system_src_widgets_inputs_text_form_field_text_form_field_use_case
                                .buildTextFormFieldErrorUseCase,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Prefix Icon',
                        builder:
                            _design_system_src_widgets_inputs_text_form_field_text_form_field_use_case
                                .buildTextFormFieldPrefixUseCase,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
