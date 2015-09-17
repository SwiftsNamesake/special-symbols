SpecialSymbolsView    = require './special-symbols-view'
{CompositeDisposable} = require 'atom'
$ = require 'jquery'

module.exports = SpecialSymbols =
  specialSymbolsView: null
  modalPanel: null
  subscriptions: null

  # TODO: Refactor, make configurable (via json or cson)
  # TODO: Arbitrary code point insertions
  # Symbol sets
  # Greek    = # { unicodedata.name(L).split()[-1].lower() : L for L in map(chr, range(945, 970)) }
  # Math     : { 'multiply': '×', 'div': '÷', 'sqrt': '√', 'element': '∈', 'angle': '∠', 'proportional': '∝', 'le': '≤', 'ge': '≥', 'ne': '≠', 'aeq': '≈', 'plmi': '±' }
  # Sets     : { 'real': 'R', 'ratio': 'Q', 'naturals': 'ℕ', 'reals': 'ℤ', 'rationals': 'ℚ'}
  # Misc     : { 'check': '✓', 'cross': '✗' } # EUREKA
  # Haskell  : { 'annot': '::', 'ldarrow' :'⇒', 'forall' :'∀', 'larrow' :'→', 'rarrow' :'←', 'ltarrow' :'↢', 'rtarrow' :'↣', 'bstar' :'★'}
  # Currency : { 'gbp' : '£', 'usd' : '$' }
  # CoffeeK  : { 'brl': '{' ,'brr': '}', 'brlr': '{}', 'sql': '[', 'sqr': ']', 'sqlr': '[]', 'vb': '|', 'bs': '\\', 'at': '@'} # Keys that no longer function due to coffee spillage
  # Music    : { 'sharp': '♯', 'flat': '♭' }
  # replacements : $.extend @Math @Sets @Misc @Haskell @Currency @CoffeeK # Greek

  replacements: { 'theta': '\u03b8', 'zeta': '\u03b6', 'alpha': '\u03b1', 'xi': '\u03be', 'gamma': '\u03b3', 'mu': '\u03bc', 'nu': '\u03bd', 'omicron': '\u03bf', 'pi': '\u03c0', 'lamda': '\u03bb', 'omega': '\u03c9', 'eta': '\u03b7', 'sigma': '\u03c3', 'tau': '\u03c4', 'epsilon': '\u03b5', 'psi': '\u03c8', 'rho': '\u03c1', 'iota': '\u03b9', 'phi': '\u03c6', 'kappa': '\u03ba', 'beta': '\u03b2', 'upsilon': '\u03c5', 'delta': '\u03b4', 'chi': '\u03c7', 'multiply': '×', 'div': '÷', 'sqrt': '√', 'element': '∈', 'angle': '∠', 'proportional': '∝', 'le': '≤', 'ge': '≥', 'ne': '≠', 'aeq': '≈', 'plmi': '±', 'real': 'R', 'ratio': 'Q', 'naturals': 'ℕ', 'reals': 'ℤ', 'rationals': 'ℚ', 'check': '✓', 'cross': '✗', 'gbp' : '£', 'usd' : '$', 'annot': '::', 'ldarrow' :'⇒', 'forall' :'∀', 'larrow' :'→', 'rarrow' :'←', 'ltarrow' :'↢', 'rtarrow' :'↣', 'bstar' :'★', 'bs': '\\' }


  activate: (state) ->
    @specialSymbolsView = new SpecialSymbolsView(state.specialSymbolsViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @specialSymbolsView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'special-symbols:toggle': => @toggle()
    atom.commands.add 'atom-workspace', "special-symbols:convert", => @convert()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @specialSymbolsView.destroy()

  serialize: ->
    specialSymbolsViewState: @specialSymbolsView.serialize()

  toggle: ->
    console.log 'SpecialSymbols was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  convert: ->
    # TODO: Multiple selection pi
    # This assumes the active pane item is an editor
    editor    = atom.workspace.getActivePaneItem()
    selection = editor.getLastSelection()

    alias  = selection.getText()
    symbol = @replacements[alias]
    if symbol == undefined
      console.error 'No replacement for '
    else
      console.log 'Found replacement for'
      selection.insertText symbol
