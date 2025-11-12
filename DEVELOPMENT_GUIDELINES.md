# 🎯 Tal3a App Development Guidelines

## 📋 **CRITICAL: Read This Before Making ANY Changes**

This document contains the **MANDATORY** guidelines for all development work on the Tal3a app. **ALWAYS** read this before making any changes to ensure consistency and code quality.

---

## 🏗️ **Project Structure Guidelines**

### **Screen Organization**
```
lib/features/[feature_name]/presentation/
├── screens/
│   └── [screen_name]_screen.dart
└── widgets/
    └── [screen_name]/
        ├── [widget_name]_widget.dart
        ├── [another_widget]_widget.dart
        └── ...
```

### **Widget Folder Structure**
- **EVERY screen MUST have its own widget folder**
- **EVERY widget MUST be in a separate file**
- **NO widgets should be inline in screen files**
- **SHARED widgets go in `lib/core/widgets/`**

**Example:**
```
lib/features/auth/presentation/widgets/
├── signin_screen/
│   ├── auth_toggle_widget.dart
│   ├── login_form_widget.dart
│   ├── signup_form_widget.dart
│   └── social_login_widget.dart
├── choose_verification_screen/
│   └── choose_verification_form_widget.dart
└── forgot_password_screen/
    └── forgot_password_form_widget.dart

lib/core/widgets/
├── primary_button_widget.dart
├── secondary_button_widget.dart
├── custom_text_field_widget.dart
└── widgets.dart (export file)
```

---

## 🎨 **Design System Guidelines**

### **MANDATORY: Use These Files for ALL Styling**

#### **1. Colors - `lib/core/const/color_pallete.dart`**
```dart
// ✅ ALWAYS use ColorPalette constants
ColorPalette.primaryBlue
ColorPalette.textWhite
ColorPalette.forgotPasswordBg

// ❌ NEVER use hardcoded colors
Color(0xFF2BB8FF) // WRONG!
Colors.blue // WRONG!
```

#### **2. Dimensions - `lib/core/const/dimentions.dart`**
```dart
// ✅ ALWAYS use Dimensions constants
Dimensions.paddingLarge
Dimensions.radiusMedium
Dimensions.spacingMedium

// ❌ NEVER use hardcoded values
EdgeInsets.all(20.0) // WRONG!
BorderRadius.circular(14.0) // WRONG!
```

#### **3. Text Styles - `lib/core/const/text_style.dart`**
```dart
// ✅ ALWAYS use AppTextStyles
AppTextStyles.titleStyle
AppTextStyles.formDescriptionStyle
AppTextStyles.tabButtonStyle

// ❌ NEVER use inline TextStyle
TextStyle(fontSize: 16, fontWeight: FontWeight.w600) // WRONG!
```

### **Adding New Text Styles**
When you need a new text style:
1. **Add it to `AppTextStyles` class**
2. **Follow the naming convention**: `[purpose][Type]Style`
3. **Use existing color constants from ColorPalette**
4. **Include all properties**: color, fontSize, fontWeight, fontFamily, height, letterSpacing

**Example:**
```dart
// Add to AppTextStyles class
static TextStyle get verificationTitleStyle => const TextStyle(
  color: ColorPalette.textDark,
  fontSize: 18,
  fontWeight: FontWeight.w600,
  fontFamily: 'Plus Jakarta Sans',
  height: 1.5,
  letterSpacing: 0.2,
);
```

### **Core Widgets Usage**
For commonly used widgets across multiple screens:

#### **Primary Button:**
```dart
import '../../../../core/widgets/widgets.dart';

PrimaryButtonWidget(
  text: 'Continue',
  onPressed: () {
    // Handle button press
  },
  isLoading: false,
  isEnabled: true,
)
```

#### **Secondary Button (Text Button):**
```dart
import '../../../../core/widgets/widgets.dart';

SecondaryButtonWidget(
  text: 'Forgot Password',
  onPressed: () {
    // Handle button press
  },
)
```

#### **Custom Text Field:**
```dart
import '../../../../core/widgets/widgets.dart';

CustomTextFieldWidget(
  controller: _emailController,
  hintText: 'Email',
  keyboardType: TextInputType.emailAddress,
  suffixIcon: Icon(Icons.email),
)
```

---

## 📱 **Screen Structure Guidelines**

### **MANDATORY Screen Pattern**
Every screen MUST follow this exact structure:

```dart
class [ScreenName]Screen extends StatelessWidget {
  const [ScreenName]Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Background Section
          Container(
            height: screenHeight,
            width: double.infinity,
            color: ColorPalette.[appropriateBackgroundColor],
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Top padding
                  
                  // Back Button (if needed)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/back_button.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Title
                  Text(
                    '[Screen Title]',
                    style: AppTextStyles.titleStyle,
                  ),

                  const SizedBox(height: 20),

                  // Progress Indicators (if multi-step)
                  Row(
                    children: [
                      // Progress bars using ColorPalette.primaryBlue and ColorPalette.progressInactive
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // Form Overlay
          Positioned(
            top: screenHeight * 0.25 - 24, // Overlap by 24px
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: ColorPalette.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Screen-specific widgets
                    const [ScreenName]FormWidget(),

                    const SizedBox(height: Dimensions.spacingMedium),

                    // Home Indicator
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Container(
                          width: 150,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A181A),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🧩 **Widget Guidelines**

### **Widget Structure Pattern**
```dart
class [WidgetName]Widget extends StatefulWidget {
  const [WidgetName]Widget({super.key});

  @override
  State<[WidgetName]Widget> createState() => _[WidgetName]WidgetState();
}

class _[WidgetName]WidgetState extends State<[WidgetName]Widget> {
  // State variables

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Widget content using ColorPalette, Dimensions, and AppTextStyles
      ],
    );
  }
}
```

### **Form Widget Guidelines**
- **Use Container with proper decoration**
- **Use Stack with Positioned for precise layouts**
- **Follow Figma designs exactly**
- **Use proper spacing with Dimensions constants**

---

## 🚫 **CRITICAL: What NOT to Do**

### **❌ NEVER Use These:**
1. **Hardcoded colors**: `Color(0xFF2BB8FF)`
2. **Hardcoded dimensions**: `EdgeInsets.all(20.0)`
3. **Inline text styles**: `TextStyle(fontSize: 16)`
4. **copyWith()**: Always create new styles
5. **Inline widgets in screen files**
6. **Mixed folder structures**

### **❌ NEVER Do This:**
```dart
// WRONG - Hardcoded values
Container(
  padding: EdgeInsets.all(20.0),
  decoration: BoxDecoration(
    color: Color(0xFF2BB8FF),
    borderRadius: BorderRadius.circular(14.0),
  ),
  child: Text(
    'Title',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF111111),
    ),
  ),
)
```

### **✅ ALWAYS Do This:**
```dart
// CORRECT - Using constants
Container(
  padding: EdgeInsets.all(Dimensions.paddingLarge),
  decoration: BoxDecoration(
    color: ColorPalette.primaryBlue,
    borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
  ),
  child: Text(
    'Title',
    style: AppTextStyles.titleStyle,
  ),
)
```

---

## 📐 **Responsive Design Guidelines**

### **Use ScreenUtil for Responsive Design**
```dart
// For responsive text sizes
fontSize: 16.h, // Use .h for height-based scaling
fontSize: 16.sp, // Use .sp for font scaling

// For responsive dimensions
width: 100.w, // Use .w for width-based scaling
height: 50.h, // Use .h for height-based scaling
```

### **Layout Guidelines**
- **Use MediaQuery for screen dimensions**
- **Use Flexible/Expanded for responsive layouts**
- **Test on different screen sizes**

---

## 🎯 **Figma Integration Guidelines**

### **🚨 CRITICAL: ALWAYS Use Figma MCP Server First**

**BEFORE making ANY UI changes, you MUST:**
1. **Connect to Figma MCP server**
2. **Get the exact design code**
3. **Get the visual image**
4. **Extract ALL design tokens**
5. **Implement EXACTLY as designed**

### **📋 Mandatory Figma Workflow:**

#### **Step 1: Get Figma Design**
```bash
# ALWAYS start with these calls
mcp_Figma_get_code(nodeId="", clientFrameworks="flutter", clientLanguages="dart")
mcp_Figma_get_image(nodeId="", clientFrameworks="flutter", clientLanguages="dart")
```

#### **Step 2: Extract Design Tokens**
From the Figma code, extract:
- **Colors**: Add to `ColorPalette`
- **Fonts**: Add to `AppTextStyles`
- **Dimensions**: Add to `Dimensions`
- **Images/Icons**: Download and add to assets
- **Layout**: Follow exact positioning

#### **Step 3: Implement Exactly**
- **Use exact colors from Figma**
- **Use exact fonts and sizes**
- **Use exact spacing and positioning**
- **Use exact border radius and shadows**
- **Use exact images and icons**

### **🎨 Design Fidelity Requirements**

#### **✅ MANDATORY: Match Figma Exactly**

**Colors:**
- **Extract exact hex values** from Figma
- **Add to ColorPalette** with descriptive names
- **Use ColorPalette constants** in code
- **NO color approximations**

**Typography:**
- **Extract exact font families** (Rubik, Plus Jakarta Sans, Inter, etc.)
- **Extract exact font sizes** (16px, 18px, 25px, etc.)
- **Extract exact font weights** (300, 400, 500, 600, 700)
- **Extract exact line heights** (1.5, 1.875, etc.)
- **Extract exact letter spacing** (0.48px, 0.75px, etc.)

**Layout & Spacing:**
- **Extract exact padding values** (20px, 14px, etc.)
- **Extract exact margins** (16px, 20px, etc.)
- **Extract exact border radius** (14px, 24px, etc.)
- **Extract exact dimensions** (76px height, 52px height, etc.)

**Images & Icons:**
- **Download exact images** from Figma
- **Use exact icon assets** provided
- **Match exact sizes** (48x48, 24x24, etc.)
- **Use exact positioning** (left: 19.5px, top: 14px, etc.)

**Shadows & Effects:**
- **Extract exact shadow values** (2px 6px 25px rgba(0,0,0,0.05))
- **Extract exact border colors** (#E3E7EC with 0.7 opacity)
- **Extract exact gradients** if any

### **📐 Layout Fidelity Guidelines**

#### **Positioning:**
```dart
// ✅ CORRECT - Use exact Figma positioning
Positioned(
  left: 19.5, // Exact from Figma
  top: 14,    // Exact from Figma
  child: Container(
    width: 24,  // Exact from Figma
    height: 24, // Exact from Figma
  ),
)

// ❌ WRONG - Approximated values
Positioned(
  left: 20,   // WRONG - Not exact
  top: 15,    // WRONG - Not exact
  child: Container(
    width: 25,  // WRONG - Not exact
    height: 25, // WRONG - Not exact
  ),
)
```

#### **Spacing:**
```dart
// ✅ CORRECT - Use exact Figma spacing
const SizedBox(height: 20), // Exact from Figma
const SizedBox(width: 16),  // Exact from Figma

// ❌ WRONG - Approximated spacing
const SizedBox(height: 18), // WRONG - Not exact
const SizedBox(width: 15),  // WRONG - Not exact
```

### **🎯 Font Implementation**

#### **Extract from Figma Code:**
```javascript
// From Figma code like this:
font-['Plus_Jakarta_Sans:SemiBold',_sans-serif] font-semibold
text-[16px] tracking-[0.08px] leading-[24px]
```

#### **Add to AppTextStyles:**
```dart
// Add to AppTextStyles class
static TextStyle get verificationOptionTitleStyle => const TextStyle(
  color: Color(0xFF111111), // Exact from Figma
  fontSize: 16,             // Exact from Figma
  fontWeight: FontWeight.w600, // SemiBold = 600
  fontFamily: 'Plus Jakarta Sans', // Exact from Figma
  height: 1.5,              // 24px / 16px = 1.5
  letterSpacing: 0.08,      // Exact from Figma
);
```

### **🎨 Color Implementation**

#### **Extract from Figma Code:**
```javascript
// From Figma code like this:
text-[#111111] // Title color
text-[#78828A] // Subtitle color
bg-[#2bb8ff]   // Button color
```

#### **Add to ColorPalette:**
```dart
// Add to ColorPalette class
static const Color verificationTitleColor = Color(0xFF111111);
static const Color verificationSubtitleColor = Color(0xFF78828A);
static const Color continueButtonColor = Color(0xFF2BB8FF);
```

### **📱 Component Implementation**

#### **Form Cards:**
```dart
// ✅ CORRECT - Exact Figma implementation
Container(
  width: double.infinity,
  height: 76, // Exact from Figma
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14), // Exact from Figma
    border: Border.all(
      color: const Color(0xFFE3E7EC).withOpacity(0.7), // Exact from Figma
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05), // Exact from Figma
        offset: const Offset(2, 6),            // Exact from Figma
        blurRadius: 25,                        // Exact from Figma
        spreadRadius: 0,
      ),
    ],
  ),
)
```

### **🖼️ Asset Management**

#### **Images & Icons:**
1. **Download from Figma** using the provided URLs
2. **Add to appropriate assets folder** (`assets/images/`, `assets/icons/`)
3. **Use exact dimensions** from Figma
4. **Update pubspec.yaml** if needed

```dart
// ✅ CORRECT - Use exact asset
Image.asset(
  'assets/icons/back_button.png',
  width: 48,  // Exact from Figma
  height: 48, // Exact from Figma
  fit: BoxFit.contain,
)
```

### **🔍 Quality Assurance**

#### **Before Finalizing:**
1. **Compare with Figma image** side by side
2. **Check all colors** match exactly
3. **Check all fonts** match exactly
4. **Check all spacing** matches exactly
5. **Check all positioning** matches exactly
6. **Check all shadows** match exactly
7. **Check all border radius** matches exactly

#### **Common Mistakes to Avoid:**
- ❌ **Approximating values** instead of using exact Figma values
- ❌ **Using different fonts** than specified in Figma
- ❌ **Using different colors** than specified in Figma
- ❌ **Using different spacing** than specified in Figma
- ❌ **Using different positioning** than specified in Figma
- ❌ **Missing shadows or effects** from Figma
- ❌ **Using wrong border radius** values

### **📋 Figma Integration Checklist**

Before implementing any UI:

- [ ] Called `mcp_Figma_get_code` to get design
- [ ] Called `mcp_Figma_get_image` to see visual
- [ ] Extracted all colors and added to ColorPalette
- [ ] Extracted all fonts and added to AppTextStyles
- [ ] Extracted all dimensions and added to Dimensions
- [ ] Downloaded all images/icons to assets
- [ ] Used exact positioning values from Figma
- [ ] Used exact spacing values from Figma
- [ ] Used exact border radius from Figma
- [ ] Used exact shadows from Figma
- [ ] Compared final result with Figma image
- [ ] Verified all colors match exactly
- [ ] Verified all fonts match exactly
- [ ] Verified all spacing matches exactly

### **🚨 CRITICAL REMINDER**

**NEVER implement UI without:**
1. **Getting Figma design first**
2. **Extracting exact design tokens**
3. **Using exact values from Figma**
4. **Comparing with Figma image**

**The goal is 100% design fidelity - every pixel should match Figma exactly!**

---

## 🔄 **Code Quality Guidelines**

### **File Organization:**
- **One widget per file**
- **Descriptive file names**
- **Proper folder structure**
- **Clean imports**

### **Code Style:**
- **Consistent indentation**
- **Proper spacing**
- **Clear variable names**
- **Comments for complex logic**

### **Performance:**
- **Use const constructors where possible**
- **Avoid unnecessary rebuilds**
- **Optimize widget trees**

---

## 📝 **Checklist Before Committing**

Before making any changes, ensure:

- [ ] Read this guideline document
- [ ] Used ColorPalette for all colors
- [ ] Used Dimensions for all spacing/sizes
- [ ] Used AppTextStyles for all text
- [ ] Created separate widget files
- [ ] Followed screen structure pattern
- [ ] Added new styles to appropriate files
- [ ] No hardcoded values
- [ ] No copyWith() usage
- [ ] Proper folder structure
- [ ] Responsive design considerations
- [ ] Figma design accuracy

---

## 🎨 **Design System Reference**

### **Available Colors:**
- `ColorPalette.primaryBlue` - #2BB8FF
- `ColorPalette.secondaryBlue` - #00AAFF
- `ColorPalette.textWhite` - #FFFFFF
- `ColorPalette.textDark` - #354F5C
- `ColorPalette.forgotPasswordBg` - #081E29
- `ColorPalette.progressInactive` - #354F5C

### **Available Dimensions:**
- `Dimensions.paddingLarge` - 20.0
- `Dimensions.radiusMedium` - 14.0
- `Dimensions.spacingMedium` - 20.0
- `Dimensions.buttonHeight` - 52.0

### **Available Text Styles:**
- `AppTextStyles.titleStyle`
- `AppTextStyles.formDescriptionStyle`
- `AppTextStyles.tabButtonStyle`
- `AppTextStyles.formInputTextStyle`

---

## 🚀 **Quick Start Template**

When creating a new screen:

1. **Create screen file**: `[name]_screen.dart`
2. **Create widget folder**: `widgets/[name]_screen/`
3. **Create form widget**: `[name]_form_widget.dart`
4. **Follow the screen structure pattern**
5. **Use all constants from design system**
6. **Test responsiveness**

---

**Remember: Consistency is key! Always follow these guidelines to maintain a clean, scalable, and maintainable codebase.**
