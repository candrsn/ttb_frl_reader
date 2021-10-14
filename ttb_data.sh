#ttb data injection

# stop on error
set -e

get_ttb_pr() {
    # keep plowing forward
    set +e

    browser='"\"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36\""'
    flg1=' -e "\"www.ttb.gov/foia/frl.shtml\"" '
    flg2="-A ${browser}"

    flg2=''

    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-puerto-rico-permits.xlsx" $flg1 $flg2
    
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-spirits-producers-and-bottlers.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ak-to-fl.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ga-to-in.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ks-to-me.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-mi-to-nh.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-nj-to-ny.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-oh-to-pa.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ri-to-tx.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ut-to-wy.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ca-alameda-to-monterey.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ca-napa-to-sanfrancisco.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-wholesalers-ca-sanjoaquin-to-yuba.xlsx" $flg1 $flg2

    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-ak-to-az-and-co-to-ky.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-la-to-nc.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-nd-to-ny.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-oh-to-or.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-pa-to-wy.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-wa.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-ca-alameda-to-monterey.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-ca-napa.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-ca-nevada-to-sanmateo.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-ca-santa-barbara-to-yuba.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-wine-producers-and-blenders-ca-sonoma.xlsx" $flg1 $flg2

    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-spirits-producers-and-bottlers.xlsx" $flg1 $flg2

    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-ak-to-fl.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-ga-to-in.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-ks-to-mt.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-nc-to-ny.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-oh-to-tx.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-ut-to-wy.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-ca-alameda-to-napa.xlsx" $flg1 $flg2
    curl -L -O "https://www.ttb.gov/images/foia/frl/frl-alcohol-importers-ca-nevada-to-yuba.xlsx" $flg1 $flg2

}

main() {
    dt="$1"
    if [ -d data/${dt} ]; then
        return
        :
    fi

    mkdir -p data/${dt} | :
    pushd data/${dt}
    get_ttb_pr
    popd
}

import() {
    dt="$1"
    pushd data/${dt}

    python3 ../../ttb_parse.py

    popd
}

dt=`date +%Y%m%d`
main $dt
import $dt
