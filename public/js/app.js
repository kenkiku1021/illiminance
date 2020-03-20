const INTERVAL = 5000;

const Data = {
    list: [],

    fetch: function() {
        return m.request({
            url: "values",
            method: "GET",
        }).then(function(data) {
            Data.list = data.map(function(item) {
                if(item) {
                    const t = new Date(item.at);
                    item.at = t.toLocaleString();
                }
                return item;
            });
        }).catch(function(e) {
            console.log(e);
        });
    },

    start: function() {
        Data.fetch();
        setInterval(function() {
            Data.fetch();
        }, INTERVAL);
    },
};

const HeaderView = {
    view: function(vnode) {
        return m("nav.navbar.navbar-expand-md.navbar-light.bg-light.fixed-top", [
            m("a.navbar-brand[href=#]", "在室チェッカー"),
        ]);
    },
};

const TopPage = {
    oninit: function(vnode) {
        Data.start();
    },
    
    view: function(vnode) {
        return [
            m(HeaderView),
            m(".container", [
                m(".d-flex.flex-wrap", [
                    Data.list.map(function(item) {
                        return m(".card.data-card", [
                            m("h5.card-header", item.title),
                            m(".card-body", [
                                m(".status", {
                                    class: item.light_on ? "on" : "off",
                                }, item.light_on ? "点灯" : "消灯"),
                                m(".at", item.at),
                            ]),
                        ]);
                    }),
                ]),
            ]),
        ];
    },
};

m.route(document.body, "/top", {
    "/top": TopPage,
});
