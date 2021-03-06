import 'dart:io' as io;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'to_render.dart';

/// We use `TEMPLATE_VALUE` comments to mark places where placeholder values
/// should be replaced with actual values that depend on the which library to
/// import, which widget to instantiate and render, the size of the preview
/// canvas, etc.
void main() async {
  Map<String, dynamic> asyncError;
  FlutterError.onError = (FlutterErrorDetails e) {
    if (e.silent) return;

    // TODO(devoncarew): Should we report and display non-fatal errors?
    if (e.stack == null) return;

    asyncError = {
      'when': 'async',
      'exception': '${e.exception}',
      'stackTrace': '${e.stack}',
      'library': e.library,
      'context': e.context
    };
  };

  final binding = WidgetsFlutterBinding.ensureInitialized();

  // ignore: invalid_use_of_protected_member
  binding.registerServiceExtension(
    name: 'designer.render',
    callback: (request) async {
      try {
        asyncError = null;
        var result = renderOnce(binding);
        if (asyncError != null) {
          return asyncError;
        }
        return result ?? {};
      } catch (e, st) {
        return {
          'when': 'sync',
          'exception': '$e',
          'stackTrace': '$st',
        };
      }
    },
  );

  // Listen for the stream to keep the process alive.
  io.stdin.listen((bytes) {});
}

Iterable<Element> collectAllElementsFrom(Element rootElement) =>
    new CachingIterable<Element>(new _DepthFirstElementIterator(rootElement));

Map<String, dynamic> renderOnce(WidgetsBinding binding) {
  var rootWidget = new AlbumsView.forDesignTime();
  var app = new _DesignerApp(rootWidget);

  Map<int, Widget> registeredWidgets =
      flutterDesignerWidgets;
  registeredWidgets.clear();

  {
    binding.attachRootWidget(app);
    binding.scheduleFrame();
    binding.handleBeginFrame(new Duration(milliseconds: 0));
    binding.handleDrawFrame();
  }

  Element rootElement = WidgetsBinding.instance.renderViewElement;
  Iterable<Element> allElements = collectAllElementsFrom(rootElement);
  var allElementsMap = <Widget, Element>{};
  for (var element in allElements) {
    allElementsMap[element.widget] = element;
  }

  var rootInfo = ElementInfo.buildHierarchy(allElementsMap, registeredWidgets);
  if (rootInfo == null) {
    return null;
  }

  var map = <String, Object>{};
  rootInfo.appendToJson(map);
  return map;
}

class ElementInfo {
  final ElementInfo parent;
  final int id;
  final ui.Rect globalBounds;
  final List<ElementInfo> children = <ElementInfo>[];

  ElementInfo(this.parent, this.id, this.globalBounds) {
    parent?.children?.add(this);
  }

  void appendToJson(Map<String, Object> json) {
    int left = globalBounds.left.truncate();
    int top = globalBounds.top.truncate();
    int right = globalBounds.right.truncate();
    int bottom = globalBounds.bottom.truncate();
    json['$id'] = {
      'globalBounds': {
        'left': left,
        'top': top,
        'width': right - left,
        'height': bottom - top,
      }
    };

    for (var child in children) {
      child.appendToJson(json);
    }
  }

  static ElementInfo buildHierarchy(
      Map<Widget, Element> elementsMap, Map<int, Widget> registeredWidgets) {
    var elementToId = new Map<Element, int>.identity();
    var elementToInfoMap = <Element, ElementInfo>{};

    registeredWidgets.forEach((id, widget) {
      final Element element = elementsMap[widget];
      if (element != null) {
        elementToId[element] = id;
      }
    });

    Element getInterestingAncestor(Element element) {
      Element ancestor;
      element.visitAncestorElements((Element candidate) {
        ancestor = candidate;
        return !elementToId.containsKey(candidate);
      });
      return ancestor;
    }

    ElementInfo createInfoForElement(Element element) {
      var id = elementToId[element];
      if (id == null) {
        return null;
      }

      var info = elementToInfoMap[element];
      if (info == null) {
        Element ancestor = getInterestingAncestor(element);
        ElementInfo ancestorInfo = createInfoForElement(ancestor);
        RenderObject renderObject = element.renderObject;
        ui.Rect globalBounds = getGlobalBounds(renderObject);
        // TODO(scheglov) Think about offstage elements.
        // https://github.com/flutter/flutter-intellij/pull/1882#discussion_r172446305
        info = new ElementInfo(ancestorInfo, id, globalBounds);
        elementToInfoMap[element] = info;
      }
      return info;
    }

    elementToId.keys.forEach(createInfoForElement);

    for (var elementInfo in elementToInfoMap.values) {
      if (elementInfo.parent == null) {
        return elementInfo;
      }
    }

    return null;
  }

  static ui.Rect getGlobalBounds(RenderObject renderObject) {
    ui.Rect semanticBounds = renderObject.semanticBounds;
    Matrix4 globalTransform = renderObject.getTransformTo(null);
    return MatrixUtils.transformRect(globalTransform, semanticBounds);
  }
}

class _DepthFirstElementIterator implements Iterator<Element> {
  final List<Element> _stack;
  Element _current;

  _DepthFirstElementIterator(Element rootElement)
      : _stack = _reverseChildrenOf(rootElement).toList();

  @override
  Element get current => _current;

  @override
  bool moveNext() {
    if (_stack.isEmpty) {
      return false;
    }

    _current = _stack.removeLast();

    // Stack children in reverse order to traverse first branch first
    _stack.addAll(_reverseChildrenOf(_current));

    return true;
  }

  static Iterable<Element> _reverseChildrenOf(Element element) {
    assert(element != null);
    final children = <Element>[];
    element.debugVisitOnstageChildren(children.add);
    return children.reversed;
  }
}

class _DesignerApp extends StatelessWidget {
  final Widget widget;

  const _DesignerApp(this.widget);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new Center(
          child: new SizedBox(
            width: 875.0,
            height: 1681.0,
            child: widget,
          ),
        ),
      ),
    );
  }
}
