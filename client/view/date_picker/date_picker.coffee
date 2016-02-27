# based on: https://github.com/chrisharrington/a-react-datepicker
div = React.createFactory 'div'
select = React.createFactory 'select'
option = React.createFactory 'option'

DateUtilities =
    pad: (value, length) ->
        while (value.length < length)
            value = "0" + value
        value

    clone: (date)->
        new Date(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds())

    toString: (date)->
        date.getFullYear() + "-" + DateUtilities.pad((date.getMonth()+1).toString(), 2) + "-" + DateUtilities.pad(date.getDate().toString(), 2)

    toDayOfMonthString: (date)->
        return DateUtilities.pad(date.getDate().toString())

    toMonthString: (date)->
        months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        months[date.getMonth()]

    toYearString: (date)->
        return '' + date.getFullYear()

    moveToDayOfWeek: (date, dayOfWeek)->
        while (date.getDay() != dayOfWeek)
            date.setDate(date.getDate()-1)
        date

    isSameDay: (first, second)->
        first.getFullYear() == second.getFullYear() && first.getMonth() == second.getMonth() && first.getDate() == second.getDate()

    isBefore: (first, second)->
        first.getTime() < second.getTime()

    isAfter: (first, second)->
        first.getTime() > second.getTime()

@DatePicker = React.createClass
    displayName: "exports"
    getInitialState: ()->
        def = @props.selected || new Date()
        #return
        view: DateUtilities.clone(def)
        selected: DateUtilities.clone(def)
        minDate: null
        maxDate: null
        id: @getUniqueIdentifier()

    componentDidMount: ->
        document.addEventListener("click", this.hideOnDocumentClick)

    componentWillUnmount: ->
        document.removeEventListener("click", this.hideOnDocumentClick)

    hideOnDocumentClick: (e)->
        if e.target.className != "date-picker-trigger-" + this.state.id && !this.parentsHaveClassName(e.target, "ardp-calendar-" + this.state.id)
            this.hide()

    getUniqueIdentifier: ->
        s4 = ->
            Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)

        s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();

    parentsHaveClassName: (element, className)->
        parent = element
        while parent
            if (parent.className && parent.className.indexOf(className) > -1)
                return true

            parent = parent.parentNode

        return false

    setMinDate: (date)->
        @setState { minDate: date }

    setMaxDate: (date)->
        @setState { maxDate: date }

    onSelect: (day)->
        this.setState { selected: day }
        this.hide()

        if this.props.onSelect
            this.props.onSelect(day)

        if this.props.onChange
            eventObject = {}
            eventObject.target = {}
            eventObject.target.value = day
            @props.onChange(eventObject)

    onChange: (view)->
        console.log "DatePicker onChange view: #{view}"
        @setState
            selected: DateUtilities.clone view
            view: DateUtilities.clone view

    show: ->
        trigger = this.refs.trigger
        rect = trigger.getBoundingClientRect()
        isTopHalf = rect.top > window.innerHeight/2
        calendarHeight = 223

        @refs.calendar.show
            top: if isTopHalf
                    (rect.top + window.scrollY - calendarHeight - 3)
                else
                    (rect.top + trigger.clientHeight + window.scrollY + 3)
            left: rect.left
          ,
            @state.selected

    hide: ->
        @refs.calendar.hide()

    render: ->
        React.createElement "div", {className: "ardp-date-picker"},
            React.createElement "input",
                ref: "trigger"
                type: "text"
                className: "date-picker-trigger-" + @state.id
                readOnly: true
                value: DateUtilities.toString(@state.selected)
                onClick: @show

            React.createElement Calendar,
                ref: "calendar"
                id: @state.id
                view: @state.view
                selected: @state.selected
                onSelect: @onSelect
                onChange: @onChange
                minDate: @state.minDate
                maxDate: @state.maxDate

Calendar = React.createClass
    displayName: "Calendar"
    getInitialState: ->
        visible: false
#        view: DateUtilities.clone @props.selected

    onMove: (view, isForward)->
        @refs.weeks.moveTo view, isForward
        @props.onChange view

    onTransitionEnd: ->
        @refs.monthHeader.enable()
        @refs.yearHeader.enable()

    shouldComponentUpdate: (nextProps, nextState)->
        console.log "Calendar.shouldComponentUpdate nextProps: #{nextProps}, nextState: #{nextState}"
        true

    componentWillReceiveProps: (nextProps)->
        console.log "componentWillReceiveProps : #{nextProps?.selected}"

    show: (position, view)->
        console.log "Calendar updating state with new view: #{view}"
        @setState
            view: DateUtilities.clone @props.view
            visible: true,
            style:
                top: position.top
                left: position.left

    hide: ->
        if @state.visible
            @setState { visible: false }

    render: ->
        calendarVisible = if @state.visible then " calendar-show" else " calendar-hide"
        React.createElement "div", {ref: "calendar", className: "ardp-calendar-" + @props.id + " calendar" + calendarVisible, style: @state.style },
            React.createElement(YearHeader, {ref: "yearHeader", view: @props.selected, onMove: @onMove}),
            React.createElement(MonthHeader, {ref: "monthHeader", view: @props.selected, onMove: @onMove}),
            React.createElement(WeekHeader, null),
            React.createElement(Weeks, {ref: "weeks", view: @props.view, selected: @props.selected, onTransitionEnd: this.onTransitionEnd, onSelect: @props.onSelect, minDate: @props.minDate, maxDate: @props.maxDate})

YearHeader = React.createClass
    displayName: "YearHeader"
    getInitialState: ->
        enabled: true

    move: (view, isForward)->
        if !@state.enabled
            return

        @setState
            view: view
            enabled: false

        @props.onMove(view, isForward)

    onChange: (e)->
        console.log "value: #{e?.target?.value}"
        view = DateUtilities.clone @props.view
        view.setFullYear e.target.value
        @move view, true

    enable: ->
        @setState { enabled: true }

    generateYears: ->
        today = new Date()
        todayYear = today.getFullYear()
        # currently it is used for birthday, so years are smaller than today, will be modified later
        [0 .. 110].map (i)->
            year = todayYear - i
            option {value: year, key: year},
                year



    render: ->
        div {className: "year-header"},
            select {value: @props.view.getFullYear(), onChange: @onChange },
              @generateYears()

MonthHeader = React.createClass
    displayName: "MonthHeader"
    getInitialState: ->
        enabled: true

    moveBackward: ->
        view = DateUtilities.clone @props.view
        view.setMonth(view.getMonth()-1)
        this.move(view, false)

    moveForward: ->
        view = DateUtilities.clone @props.view
        view.setMonth(view.getMonth()+1)
        this.move(view, true)

    move: (view, isForward)->
        if not @state.enabled
            return;

        @setState
            view: view
            enabled: false

        @props.onMove(view, isForward)

    enable: ->
        @setState { enabled: true }

    render: ->
        classEnabled = if @state.enabled  then '' else ' disabled'
        React.createElement("div", {className: "month-header"},
            React.createElement("i", {className: classEnabled, onClick: this.moveBackward}, String.fromCharCode(9664)),
            React.createElement("span", null, DateUtilities.toMonthString(@props.view)),
            React.createElement("i", {className: classEnabled, onClick: this.moveForward}, String.fromCharCode(9654))
        )

WeekHeader = React.createClass
    displayName: "WeekHeader"
    render: ->
        React.createElement("div", {className: "week-header"},
            React.createElement("span", null, "Sun"),
            React.createElement("span", null, "Mon"),
            React.createElement("span", null, "Tue"),
            React.createElement("span", null, "Wed"),
            React.createElement("span", null, "Thu"),
            React.createElement("span", null, "Fri"),
            React.createElement("span", null, "Sat")
        )

Weeks = React.createClass
    displayName: "Weeks"
    getInitialState: ->
        #return
        view: DateUtilities.clone(this.props.view)
        other: DateUtilities.clone(this.props.view)
        sliding: null

    componentDidMount: ->
        this.refs.current.addEventListener("transitionend", this.onTransitionEnd);

    onTransitionEnd: ->
        @setState
            sliding: null,
            view: DateUtilities.clone(this.state.other)

        @props.onTransitionEnd()

    getWeekStartDates: (view)->
        view.setDate(1)
        view = DateUtilities.moveToDayOfWeek(DateUtilities.clone(view), 0)

        current = DateUtilities.clone view
        current.setDate(current.getDate()+7)

        starts = [view]
        month = current.getMonth()

        while (current.getMonth() == month)
            starts.push(DateUtilities.clone(current))
            current.setDate(current.getDate()+7)

        starts

    moveTo: (view, isForward)->
        @setState
            sliding: if isForward then "left" else "right"
            other: DateUtilities.clone(view)

    render: ->
        slidingState = if @state.sliding then (" sliding " + this.state.sliding) else ""

        React.createElement("div", {className: "weeks"},
            React.createElement("div", {ref: "current", className: "current" + slidingState},
                this.renderWeeks(this.state.view)
            ),
            React.createElement("div", {ref: "other", className: "other" + slidingState},
                this.renderWeeks(this.state.other)
            )
        )

    renderWeeks: (view)->
        starts = this.getWeekStartDates view
        month = starts[1].getMonth()

        starts.map (s, i)=>
            React.createElement Week,
                key: i
                start: s
                month: month
                selected: @props.selected
                onSelect: @props.onSelect
                minDate: @props.minDate
                maxDate: @props.maxDate

Week = React.createClass
    displayName: "Week"
    buildDays: (start)->
        days = [DateUtilities.clone(start)]
        clone = DateUtilities.clone start

        for i in [1..6]
            clone = DateUtilities.clone clone
            clone.setDate(clone.getDate()+1)
            days.push clone
        days

    isOtherMonth: (day)->
        @props.month != day.month()

    getDayClassName: (day)->
        className = "day"

        if DateUtilities.isSameDay(day, new Date())
            className += " today"

        if @props.month != day.getMonth()
            className += " other-month"

        if @props.selected && DateUtilities.isSameDay(day, this.props.selected)
            className += " selected"
        if this.isDisabled(day)
            className += " disabled"
        className

    onSelect: (day)->
        if not @isDisabled day
            @props.onSelect day

    isDisabled: (day)->
        minDate = this.props.minDate
        maxDate = this.props.maxDate

        # return
        (minDate && DateUtilities.isBefore(day, minDate)) || (maxDate && DateUtilities.isAfter(day, maxDate))

    render: ->
        days = @buildDays @props.start
        React.createElement "div", {className: "week"},
            days.map (day, i)=>
                React.createElement("div", {key: i, onClick: this.onSelect.bind(null, day), className: this.getDayClassName(day)}, DateUtilities.toDayOfMonthString(day))
