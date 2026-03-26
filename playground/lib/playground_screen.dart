import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'utils/web_utils.dart';
import 'component_registry.dart';
import 'component_metadata.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  ComponentMetadata? selectedComponent;
  Map<String, dynamic> currentProps = {};
  bool _isFullScreen = false;
  final Map<String, TextEditingController> _controllers = {};
  int _refreshCounter = 0;
  String _searchQuery = '';
  late TextEditingController _searchController;

  // Theme colours (customisable via Theme Editor)
  Color _canvasColor = const Color.fromARGB(255, 246, 247, 248);
  Color _themeHeaderColor = const Color(0xFF0F326A);
  Color _themeLeftSidebarColor = const Color.fromARGB(255, 208, 236, 255);
  Color _themeSearchSectionColor = Colors.white;
  Color _themeLeftSubSectionColor = const Color.fromARGB(255, 182, 205, 225);
  Color _themeRightSidebarColor = const Color(0xFFE0F2FE);
  Color _themeRightSubSectionColor = const Color.fromRGBO(0, 0, 0, 0.05);
  Color _themeRightSubSectionInnerColor = Colors.white;

  // Resizable panels
  double _sidebarWidth = 320.0;
  double _propertiesWidth = 320.0;
  final double _minPanelWidth = 260.0;
  final double _maxPanelWidth = 520.0;
  bool _isHoveringLeftHandle = false;
  bool _isHoveringRightHandle = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, bool> _expandedCategories = {
    'Atoms': false,
    'Molecules': false,
    'Organisms': false,
    'Pages': false,
  };

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (componentRegistry.isNotEmpty) {
      selectedComponent = componentRegistry.first;
      currentProps = Map.from(selectedComponent!.defaultProps);
      _ensureOffsetProps();
      _updateControllers();
    }
    if (kIsWeb) {
      WebUtils.onFullscreenChange.listen((event) {
        if (!WebUtils.isFullscreen && mounted) {
          setState(() => _isFullScreen = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, c) => c.dispose());
    _searchController.dispose();
    super.dispose();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _updateControllers() {
    _controllers.forEach((_, c) => c.dispose());
    _controllers.clear();
    currentProps.forEach((key, value) {
      if (value is String) {
        _controllers[key] = TextEditingController(text: value);
      } else if (value is double || value is int) {
        _controllers[key] = TextEditingController(
          text: value is double ? value.toStringAsFixed(2) : value.toString(),
        );
      }
    });
  }

  void _ensureOffsetProps() {
    if (selectedComponent == null) return;
    final needsOffset = selectedComponent!.category == 'Molecules' ||
        [
          'Text', 'Text Field', 'Button', 'Checkbox', 'Text Button',
          'Image', 'Radio Button', 'Toggle Switch'
        ].contains(selectedComponent!.name);
    if (needsOffset) {
      currentProps.putIfAbsent('xOffset', () => 0.0);
      currentProps.putIfAbsent('yOffset', () => 0.0);
    }
  }

  void _toggleFullScreen(bool value) {
    setState(() => _isFullScreen = value);
    if (kIsWeb) {
      if (value) {
        WebUtils.requestFullscreen();
      } else if (WebUtils.isFullscreen) {
        WebUtils.exitFullscreen();
      }
    }
  }

  String _formatName(String s) {
    if (s.isEmpty) return s;
    final formatted = s.replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'), (m) => '${m.group(1)} ${m.group(2)}');
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: _canvasColor,
        body: Stack(
          children: [
            _preview(),
            Positioned(
              top: 20,
              right: 20,
              child: Opacity(
                opacity: 0.25,
                child: IconButton(
                  icon: const Icon(Icons.close_fullscreen,
                      color: Color(0xFF1E1E4C), size: 30),
                  onPressed: () => _toggleFullScreen(false),
                  tooltip: 'Exit Full Screen',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final isMobileLayout = screenWidth <= 1024;

      if (isMobileLayout) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: _themeHeaderColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              tooltip: 'Components',
            ),
            title: const Text('Design System Playground',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              _buildThemeIconButton(iconColor: Colors.white),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                tooltip: 'Properties',
              ),
            ],
          ),
          drawer: Drawer(child: _sidebar()),
          endDrawer: Drawer(child: _properties()),
          body: Container(color: _canvasColor, child: _preview()),
        );
      }

      return Scaffold(
        body: Container(
          color: _canvasColor,
          child: Column(
            children: [
              _header(),
              Expanded(
                child: LayoutBuilder(builder: (context, desktopConstraints) {
                  return _buildDesktopLayout(desktopConstraints.maxWidth);
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDesktopLayout(double totalWidth) {
    const double minPreviewWidth = 400.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_isFullScreen)
          SizedBox(width: _sidebarWidth, child: _sidebar()),
        if (!_isFullScreen)
          _verticalResizeHandle(
            isHovering: _isHoveringLeftHandle,
            onHoverChanged: (v) => setState(() => _isHoveringLeftHandle = v),
            onDrag: (delta) => setState(() {
              final newW = (_sidebarWidth + delta)
                  .clamp(_minPanelWidth, _maxPanelWidth);
              if (totalWidth - newW - _propertiesWidth >= minPreviewWidth) {
                _sidebarWidth = newW;
              }
            }),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: Colors.black
                        .withValues(alpha: _isFullScreen ? 0 : 0.05),
                    width: 1),
                right: BorderSide(
                    color: Colors.black
                        .withValues(alpha: _isFullScreen ? 0 : 0.05),
                    width: 1),
              ),
            ),
            child: _preview(),
          ),
        ),
        if (!_isFullScreen)
          _verticalResizeHandle(
            isHovering: _isHoveringRightHandle,
            onHoverChanged: (v) => setState(() => _isHoveringRightHandle = v),
            onDrag: (delta) => setState(() {
              final newW = (_propertiesWidth - delta)
                  .clamp(_minPanelWidth, _maxPanelWidth);
              if (totalWidth - _sidebarWidth - newW >= minPreviewWidth) {
                _propertiesWidth = newW;
              }
            }),
          ),
        if (!_isFullScreen)
          SizedBox(width: _propertiesWidth, child: _properties()),
      ],
    );
  }

  Widget _verticalResizeHandle({
    required bool isHovering,
    required ValueChanged<bool> onHoverChanged,
    required ValueChanged<double> onDrag,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        onHorizontalDragUpdate: (d) => onDrag(d.delta.dx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isHovering ? 12 : 6,
          decoration: BoxDecoration(
            color: isHovering
                ? const Color(0xFF1E1E4C).withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              width: 2,
              color: isHovering
                  ? const Color(0xFF1E1E4C).withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
            ),
            if (isHovering)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (_) => Container(
                    width: 3,
                    height: 3,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: const BoxDecoration(
                        color: Color(0xFF1E2B4C), shape: BoxShape.circle),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _header() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: _themeHeaderColor,
      child: Row(
        children: [
          Image.asset('assets/hdfc_logo.png', height: 40,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.account_balance, color: Colors.white, size: 36)),
          const SizedBox(width: 40),
          const VerticalDivider(color: Colors.white24, indent: 18, endIndent: 18),
          const SizedBox(width: 40),
          const Text(
            'Design System Playground',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildThemeIconButton(iconColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeIconButton({required Color iconColor}) {
    return IconButton(
      icon: Icon(Icons.palette, color: iconColor),
      tooltip: 'Theme Editor',
      onPressed: _showThemeEditorDialog,
    );
  }

  // ─── Theme Editor ──────────────────────────────────────────────────────────

  void _showThemeEditorDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Theme Editor',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, anim, _, child) => SlideTransition(
        position: Tween<Offset>(
                begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
      pageBuilder: (context, _, __) {
        final dw =
            MediaQuery.of(context).size.width < 500 ? MediaQuery.of(context).size.width * 0.85 : 380.0;
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: dw,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius:
                  BorderRadius.horizontal(left: Radius.circular(24)),
            ),
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                child: StatefulBuilder(builder: (ctx, setDS) {
                  Widget row(IconData icon, String title, Color cur,
                      ValueChanged<Color> onChange) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F8),
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(icon,
                              size: 16, color: const Color(0xFF1E1E4C)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black87))),
                        _buildColorGridPopup(cur, (c) {
                          onChange(c);
                          setDS(() {});
                          setState(() {});
                        }),
                      ]),
                    );
                  }

                  Widget group(String title, List<Widget> ch) => Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                          border: Border.all(
                              color: Colors.black.withOpacity(0.04)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E4C),
                                      letterSpacing: 1.2)),
                              const SizedBox(height: 16),
                              ...ch,
                            ]),
                      );

                  return Column(children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(24)),
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.black.withOpacity(0.05))),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Theme Settings',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E4C))),
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded,
                                  color: Color(0xFF1E1E4C)),
                              tooltip: 'Reset to Default',
                              onPressed: () {
                                _themeHeaderColor = const Color(0xFF0F326A);
                                _canvasColor = const Color.fromARGB(255, 246, 247, 248);
                                _themeLeftSidebarColor = const Color.fromARGB(255, 208, 236, 255);
                                _themeSearchSectionColor = Colors.white;
                                _themeLeftSubSectionColor = const Color.fromARGB(255, 182, 205, 225);
                                _themeRightSidebarColor = const Color(0xFFE0F2FE);
                                _themeRightSubSectionColor = const Color.fromRGBO(0, 0, 0, 0.05);
                                _themeRightSubSectionInnerColor = Colors.white;
                                setDS(() {});
                                setState(() {});
                              },
                            ),
                          ]),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              group('GLOBAL', [
                                row(Icons.web_asset, 'Header Bar',
                                    _themeHeaderColor, (c) => _themeHeaderColor = c),
                                row(Icons.desktop_windows, 'Canvas',
                                    _canvasColor, (c) => _canvasColor = c),
                              ]),
                              group('LEFT PANEL', [
                                row(Icons.vertical_split, 'Main Sidebar',
                                    _themeLeftSidebarColor,
                                    (c) => _themeLeftSidebarColor = c),
                                row(Icons.search, 'Search Section',
                                    _themeSearchSectionColor,
                                    (c) => _themeSearchSectionColor = c),
                                row(Icons.widgets, 'Category Group',
                                    _themeLeftSubSectionColor,
                                    (c) => _themeLeftSubSectionColor = c),
                              ]),
                              group('RIGHT PANEL', [
                                row(Icons.dock, 'Properties Sidebar',
                                    _themeRightSidebarColor,
                                    (c) => _themeRightSidebarColor = c),
                                row(Icons.layers, 'Properties Group',
                                    _themeRightSubSectionColor,
                                    (c) => _themeRightSubSectionColor = c),
                                row(Icons.tune, 'Inner Customization',
                                    _themeRightSubSectionInnerColor,
                                    (c) => _themeRightSubSectionInnerColor = c),
                              ]),
                            ]),
                      ),
                    ),
                  ]);
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> get _extendedColorPalette => [
    Colors.white, const Color(0xFFF3F4F6), const Color(0xFFE5E7EB),
    const Color(0xFFD1D5DB), const Color(0xFF9CA3AF), const Color(0xFF4B5563), Colors.black,
    const Color(0xFFFEE2E2), const Color(0xFFFECACA), const Color(0xFFFCA5A5),
    const Color(0xFFF87171), const Color(0xFFEF4444), const Color(0xFFDC2626), const Color(0xFFB91C1C),
    const Color(0xFFFFEDD5), const Color(0xFFFED7AA), const Color(0xFFFDBA74),
    const Color(0xFFFB923C), const Color(0xFFF97316), const Color(0xFFEA580C), const Color(0xFFC2410C),
    const Color(0xFFFEF9C3), const Color(0xFFFEF08A), const Color(0xFFFDE047),
    const Color(0xFFFACC15), const Color(0xFFEAB308), const Color(0xFFCA8A04), const Color(0xFFA16207),
    const Color(0xFFDCFCE7), const Color(0xFFBBF7D0), const Color(0xFF86EFAC),
    const Color(0xFF4ADE80), const Color(0xFF22C55E), const Color(0xFF16A34A), const Color(0xFF15803D),
    const Color(0xFFEFF6FF), const Color(0xFFDBEAFE), const Color(0xFFBFDBFE),
    const Color(0xFF93C5FD), const Color(0xFF60A5FA), const Color(0xFF3B82F6), const Color(0xFF2563EB),
    const Color(0xFFF6F7F8), const Color(0xFFE5EDF4), const Color(0xFFBAE6FD),
    const Color(0xFF38BDF8), const Color(0xFF0284C7), const Color(0xFF004C8F), const Color(0xFF0F326A),
    const Color(0xFFF3E8FF), const Color(0xFFE9D5FF), const Color(0xFFD8B4FE),
    const Color(0xFFC084FC), const Color(0xFFA855F7), const Color(0xFF9333EA), const Color(0xFF7E22CE),
  ];

  Widget _buildColorGridPopup(Color currentColor, ValueChanged<Color> onChanged) {
    return PopupMenuButton<Color>(
      tooltip: 'Pick Colour',
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: currentColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 40),
      onSelected: onChanged,
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: currentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: 244,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _extendedColorPalette
                  .map((c) => GestureDetector(
                        onTap: () => Navigator.pop(ctx, c),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: currentColor == c
                                    ? Colors.black
                                    : Colors.black12,
                                width: currentColor == c ? 2.5 : 1,
                              ),
                              boxShadow: currentColor == c
                                  ? [BoxShadow(color: c.withOpacity(0.4), blurRadius: 4, spreadRadius: 1)]
                                  : null,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Sidebar ───────────────────────────────────────────────────────────────

  Widget _sidebar() {
    return Container(
      color: _themeLeftSidebarColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text('COMPONENTS',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 1.2)),
          ),
          const SizedBox(height: 8),
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: _themeSearchSectionColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search components…',
                hintStyle:
                    const TextStyle(color: Colors.black26, fontSize: 14),
                prefixIcon: const Icon(Icons.search,
                    color: Color(0xFF1E1E4C), size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          // Inline search results
          if (_searchQuery.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: componentRegistry
                        .where((c) =>
                            c.name.toLowerCase().contains(_searchQuery))
                        .map((c) => ListTile(
                              dense: true,
                              title: Text(_formatName(c.name),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 33, 179),
                                      fontWeight: FontWeight.w700)),
                              subtitle: Row(children: [
                                Text(c.category,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black45)),
                                const SizedBox(width: 6),
                                _platformBadge(c.platform),
                              ]),
                              onTap: () => _selectComponent(c),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          _categorySection('Atoms'),
          _categorySection('Molecules'),
          _categorySection('Organisms'),
          _categorySection('Pages'),
        ]),
      ),
    );
  }

  Widget _categorySection(String category) {
    final items = componentRegistry
        .where((c) =>
            c.category == category &&
            c.name.toLowerCase().contains(_searchQuery))
        .toList();

    final bool isSearching = _searchQuery.isNotEmpty;
    final bool isExpanded = isSearching
        ? items.isNotEmpty
        : (_expandedCategories[category] ?? false);

    if (isSearching && items.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _themeLeftSubSectionColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap: () => setState(
              () => _expandedCategories[category] = !isExpanded),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category,
                      style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black45,
                    size: 20,
                  ),
                ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Column(children: [
            if (items.isEmpty && !isSearching)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text('No components',
                    style: TextStyle(color: Colors.black38, fontSize: 12)),
              )
            else
              ...items.map((c) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      dense: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Row(children: [
                        Flexible(
                          child: Text(
                            _formatName(c.name),
                            style: TextStyle(
                              color: selectedComponent?.name == c.name
                                  ? const Color.fromARGB(255, 0, 33, 179)
                                  : Colors.black87,
                              fontSize: 14,
                              fontWeight:
                                  selectedComponent?.name == c.name
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _platformBadge(c.platform),
                      ]),
                      selected: selectedComponent?.name == c.name,
                      selectedTileColor: const Color(0xFFBAE6FD),
                      onTap: () => _selectComponent(c),
                    ),
                  )),
            const SizedBox(height: 12),
          ]),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ]),
    );
  }

  void _selectComponent(ComponentMetadata c) {
    setState(() {
      selectedComponent = c;
      currentProps = Map.from(c.defaultProps);
      _ensureOffsetProps();
      _updateControllers();
      _refreshCounter++;
      _searchQuery = '';
      _searchController.clear();
      _expandedCategories[c.category] = true;
      if (_scaffoldKey.currentState?.isDrawerOpen == true) {
        _scaffoldKey.currentState?.closeDrawer();
      }
    });
  }

  /// Tiny coloured badge (Mobile / Web / Shared).
  Widget _platformBadge(ComponentPlatform platform) {
    switch (platform) {
      case ComponentPlatform.mobile:
        return _badge('Mobile', const Color(0xFF1D6AE5), Colors.white);
      case ComponentPlatform.web:
        return _badge('Web', const Color(0xFF047857), Colors.white);
      case ComponentPlatform.shared:
        return _badge('Shared', const Color(0xFF6B7280), Colors.white);
    }
  }

  Widget _badge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  // ─── Preview ───────────────────────────────────────────────────────────────

  Widget _preview() {
    return Padding(
      padding:
          _isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!_isFullScreen)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  selectedComponent != null
                      ? _formatName(selectedComponent!.name)
                      : 'Select Component',
                  style: const TextStyle(
                      color: Color(0xFF1E1E4C),
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(children: [
                  Text(
                    selectedComponent?.category ?? '',
                    style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  if (selectedComponent != null) ...[ 
                    const SizedBox(width: 8),
                    _platformBadge(selectedComponent!.platform),
                  ],
                ]),
              ]),
            ),
            const Spacer(),
            // Desktop / Fullscreen toggle
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 233, 236, 237),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(6),
              child: Row(children: [
                _viewIcon(Icons.desktop_windows, !_isFullScreen,
                    () => _toggleFullScreen(false)),
                _viewIcon(Icons.fullscreen, _isFullScreen,
                    () => _toggleFullScreen(true)),
              ]),
            ),
          ]),
        if (!_isFullScreen) const SizedBox(height: 32),
        Expanded(
          child: selectedComponent == null
              ? const Center(
                  child: Text('Select a component to preview',
                      style: TextStyle(color: Colors.black38, fontSize: 16)))
              : _buildComponentCanvas(),
        ),
      ]),
    );
  }

  Widget _buildComponentCanvas() {
    final comp = selectedComponent!;
    final isMobile = comp.platform == ComponentPlatform.mobile;

    if (_isFullScreen && comp.category == 'Pages') {
      return _renderComponent(isFullScreen: true);
    }

    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          decoration: BoxDecoration(
            color: _canvasColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15))
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isMobile
                ? _mobileFrame()
                : SizedBox(
                    width: 1440,
                    height: 1024,
                    child: Center(
                      key: ValueKey(_refreshCounter),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Transform.scale(
                          scale: _getComponentScale(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: 1400 / _getComponentScale()),
                            child: _renderComponent(isFullScreen: false),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// Wraps mobile-platform components in a phone-shaped container (375 × 812).
  Widget _mobileFrame() {
    return Container(
      width: 375,
      height: 812,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 4),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(children: [
          Container(color: const Color(0xFFF8FAFC)),
          Center(
            key: ValueKey(_refreshCounter),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _renderComponent(isFullScreen: false),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _renderComponent({required bool isFullScreen}) {
    if (selectedComponent == null) return const SizedBox();
    Widget component = selectedComponent!.builder(
      currentProps,
      isFullScreen: isFullScreen,
      onUpdate: () => setState(() {}),
    );

    // Apply offset translation for molecules (except Dropdown)
    if (selectedComponent!.category == 'Molecules' &&
        selectedComponent!.name != 'Dropdown') {
      final x = (currentProps['xOffset'] as num?)?.toDouble() ?? 0.0;
      final y = (currentProps['yOffset'] as num?)?.toDouble() ?? 0.0;
      if (x != 0 || y != 0) {
        component = Transform.translate(
            offset: Offset(x, -y), child: component);
      }
    }
    return component;
  }

  double _getComponentScale() {
    if (selectedComponent == null) return 1.0;
    final name = selectedComponent!.name;
    if (name == 'NetBanking Login Page') return 1.0;
    final lower = name.toLowerCase();
    if (lower.contains('text') ||
        lower.contains('checkbox') ||
        lower.contains('toggle') ||
        lower.contains('switch') ||
        lower.contains('field')) {
      return 1.5;
    }
    return 1.2;
  }

  Widget _viewIcon(IconData icon, bool isActive, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon,
            color: isActive
                ? const Color(0xFF1E1E4C)
                : Colors.black38,
            size: 26),
      ),
    );
  }

  // ─── Properties panel ─────────────────────────────────────────────────────

  Widget _properties() {
    if (selectedComponent == null) return const SizedBox();

    return Container(
      color: _themeRightSidebarColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('PROPERTIES',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1.5)),
            Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: const Icon(Icons.code_rounded,
                    color: Colors.black, size: 22),
                onPressed: _showCodePreview,
                tooltip: 'View Code',
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: Colors.black, size: 22),
                onPressed: () {
                  setState(() {
                    currentProps =
                        Map.from(selectedComponent!.defaultProps);
                    _ensureOffsetProps();
                    _updateControllers();
                    _refreshCounter++;
                  });
                },
                tooltip: 'Reset Properties',
              ),
            ]),
          ]),
          const SizedBox(height: 16),
          // Render grouped properties
          ..._buildPropertyWidgets(),
          const SizedBox(height: 16),
          _propertyGroup(title: 'Component Info', children: [
            _infoRow('Name', selectedComponent?.name ?? ''),
            _infoRow('Category', selectedComponent?.category ?? ''),
            _infoRow('Platform',
                selectedComponent?.platform.name.toUpperCase() ?? ''),
          ]),
        ]),
      ),
    );
  }

  List<Widget> _buildPropertyWidgets() {
    final List<Widget> widgets = [];

    for (final entry in currentProps.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key.startsWith('_')) continue;

      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _renderPropertyInput(key, value),
      ));
    }

    return [
      _propertyGroup(
        title: 'Customization',
        children: widgets,
      )
    ];
  }

  Widget _renderPropertyInput(String key, dynamic value) {
    final hasOptions =
        selectedComponent?.options?.containsKey(key) ?? false;

    if (hasOptions && value is String) {
      if (key.toLowerCase().contains('size')) {
        return _propertySegmentedInput(_formatName(key), key);
      }
      return _propertyEnumInput(_formatName(key), key);
    }

    if (value is bool) return _propertyBoolInput(_formatName(key), key);
    if (value is List<String>) return _propertyListInput(_formatName(key), key);
    if (value is double || value is int) {
      return _propertyNumericInput(_formatName(key), key);
    }
    if (value is Color) return _propertyColorInput(_formatName(key), key);
    if (value is String) return _propertyTextInput(_formatName(key), key);
    if (value is FontWeight) {
      return _propertyFontWeightInput(_formatName(key), key);
    }
    return const SizedBox();
  }

  Widget _propertyGroup(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeRightSubSectionColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  Widget _propertyBoolInput(String label, String key) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
      value: currentProps[key] ?? false,
      onChanged: (v) => setState(() => currentProps[key] = v),
      activeThumbColor: const Color(0xFF1E1E4C),
    );
  }

  Widget _propertyTextInput(String label, String key) {
    final disabled = currentProps['disabled'] ?? false;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(
        enabled: !disabled,
        style: TextStyle(
            color: disabled ? Colors.black26 : Colors.black87, fontSize: 16),
        controller: _controllers[key],
        onChanged: (v) => setState(() => currentProps[key] = v),
        decoration: _inputDecoration(),
      ),
    ]);
  }

  Widget _propertyNumericInput(String label, String key) {
    final disabled = currentProps['disabled'] ?? false;
    final value = (currentProps[key] ?? 0.0).toDouble();
    final controller = _controllers[key];
    final lower = key.toLowerCase();

    double min = 0, max = 850;
    int decimals = 0;
    if (lower.contains('opacity')) { max = 1.0; decimals = 2; }
    else if (lower.contains('radius')) { max = 100.0; }
    else if (lower.contains('blur')) { max = 40.0; }
    else if (lower.contains('width')) { max = 1440.0; }
    else if (lower.contains('height')) { max = 900.0; }
    else if (lower.contains('fontsize') || lower.contains('font')) { max = 120.0; }
    else if (lower.contains('offset')) { min = -750.0; max = 750.0; }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Text(label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          width: 60,
          height: 24,
          child: TextField(
            enabled: !disabled,
            controller: controller,
            textAlign: TextAlign.right,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero),
            onChanged: (v) {
              final parsed = double.tryParse(v);
              if (parsed != null) {
                setState(() => currentProps[key] = parsed.clamp(min, max));
              }
            },
          ),
        ),
      ]),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        ),
        child: Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: disabled
              ? null
              : (v) {
                  setState(() {
                    currentProps[key] = v;
                    controller?.text = decimals > 0
                        ? v.toStringAsFixed(decimals)
                        : v.toInt().toString();
                  });
                },
          activeColor: const Color(0xFF1E1E4C),
          inactiveColor: Colors.black12,
        ),
      ),
    ]);
  }

  Widget _propertyColorInput(String label, String key) {
    final Color cur = currentProps[key] ?? Colors.black;
    return Row(children: [
      Expanded(
          child: Text(label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600))),
      _buildColorGridPopup(cur, (c) => setState(() => currentProps[key] = c)),
    ]);
  }

  Widget _propertyEnumInput(String label, String key) {
    final options = selectedComponent?.options?[key] ?? <String>[];
    if (options.isEmpty) return const SizedBox();
    final currentValue =
        options.contains(currentProps[key]) ? currentProps[key] as String : options.first;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.black54, size: 20),
            style: const TextStyle(color: Colors.black, fontSize: 14),
            items: options
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => currentProps[key] = v);
            },
          ),
        ),
      ),
    ]);
  }

  Widget _propertySegmentedInput(String label, String key) {
    final options =
        selectedComponent?.options?[key] ?? ['Small', 'Medium', 'Large'];
    final currentValue = currentProps[key]?.toString() ?? options.first;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label.isNotEmpty) ...[
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
      ],
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12)),
        child: Row(
          children: options.map((opt) {
            final selected = currentValue == opt;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  currentProps[key] = opt;
                  _refreshCounter++;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1E1E4C)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(opt,
                      style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }

  Widget _propertyFontWeightInput(String label, String key) {
    final fw = currentProps[key] ?? FontWeight.normal;
    final isBold =
        fw == FontWeight.bold || fw == FontWeight.w700;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(children: [
        GestureDetector(
          onTap: () => setState(() => currentProps[key] =
              isBold ? FontWeight.normal : FontWeight.bold),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isBold ? const Color(0xFF1E1E4C) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isBold
                      ? const Color(0xFF1E1E4C)
                      : Colors.black12,
                  width: 1.5),
            ),
            child: Text('B',
                style: TextStyle(
                    color: isBold ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ),
        const SizedBox(width: 12),
        Text(isBold ? 'Bold' : 'Normal',
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
      ]),
    ]);
  }

  Widget _propertyListInput(String label, String key) {
    final items = List<String>.from(currentProps[key] ?? []);
    final ctrl = _controllers.putIfAbsent(
        key, () => TextEditingController(text: items.join(', ')));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: ctrl,
        style: const TextStyle(fontSize: 14),
        decoration: _inputDecoration().copyWith(
            hintText: 'Item 1, Item 2, …',
            helperText: 'Separate items with commas',
            helperStyle: const TextStyle(fontSize: 10)),
        onChanged: (v) {
          setState(() => currentProps[key] =
              v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList());
        },
      ),
    ]);
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 14))),
            Text(value,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ]),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black12)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black38)),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  // ─── Code Preview dialog ───────────────────────────────────────────────────

  void _showCodePreview() {
    if (selectedComponent == null) return;
    final usageCode = _generateUsageCode();
    final implCode = selectedComponent!.implementationCode ??
        '// Implementation code not available for this component.';

    showDialog(
      context: context,
      builder: (context) => DefaultTabController(
        length: 2,
        child: AlertDialog(
          backgroundColor: const Color(0xFFF0F9FF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              const Icon(Icons.code_rounded, color: Color(0xFF1E1E4C)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_formatName(selectedComponent!.name)} Code',
                  style: const TextStyle(
                      color: Color(0xFF1E1E4C),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            const TabBar(
              labelColor: Color(0xFF1E1E4C),
              unselectedLabelColor: Colors.black38,
              indicatorColor: Color(0xFF1E1E4C),
              indicatorWeight: 3,
              tabs: [Tab(text: 'USAGE'), Tab(text: 'SOURCE CODE')],
            ),
          ]),
          content: Container(
            width: 800,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBarView(
              children: [
                _codePanel(usageCode, 'Copy and use this code in your Flutter app:'),
                _codePanel(implCode, 'Implementation code for this component:'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold)),
            ),
            Builder(builder: (ctx) {
              return ElevatedButton.icon(
                onPressed: () {
                  final idx = DefaultTabController.of(ctx).index;
                  final code = idx == 0 ? usageCode : implCode;
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(idx == 0
                        ? 'Usage code copied!'
                        : 'Source code copied!'),
                    behavior: SnackBarBehavior.floating,
                    width: 300,
                  ));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy Active Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004C8F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _codePanel(String code, String description) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(description,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: SelectableText(code,
                  style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: Color(0xFF1E1E4C),
                      height: 1.5,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ]),
    );
  }

  String _generateUsageCode() {
    if (selectedComponent == null) return 'No component selected';
    final buffer = StringBuffer();
    final className =
        selectedComponent!.name.replaceAll(' ', '');
    buffer.writeln('$className(');

    final props = Map<String, dynamic>.from(currentProps);
    if (props.containsKey('xOffset') && props.containsKey('yOffset')) {
      final x = props.remove('xOffset') ?? 0.0;
      final y = props.remove('yOffset') ?? 0.0;
      props['offset'] = Offset((x as num).toDouble(), (y as num).toDouble());
    }

    props.forEach((key, value) {
      if (key.startsWith('_')) return;
      buffer.write('  $key: ');
      if (value is String) {
        buffer.writeln("'$value',");
      } else if (value is Color) {
        final hex = value.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0');
        buffer.writeln('const Color(0x$hex),');
      } else if (value is FontWeight) {
        buffer.writeln('$value,');
      } else if (value is Offset) {
        buffer.writeln('const Offset(${value.dx}, ${value.dy}),');
      } else if (value is List) {
        buffer.write('[ ');
        buffer.write(value
            .map((e) => e is String ? "'$e'" : e.toString())
            .join(', '));
        buffer.writeln(' ],');
      } else {
        buffer.writeln('$value,');
      }
    });

    buffer.write(')');
    return buffer.toString();
  }
}
