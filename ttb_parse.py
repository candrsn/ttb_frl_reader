#ttb_parse.py

from bs4 import BeautifulSoup
import sys
import os
import sqlite3
import unicodecsv as csv
import logging
import openpyxl
import glob

logger = logging.getLogger(__name__)

def read_dom(f):
    d = open(f, 'rb')
    dr = d.read()
    dom = BeautifulSoup(dr)
    return dom
   
def parse_dom(dom):
    #current published format
    elem = dom.findAll( "table" )    
    
    return elem

def data_setup(db):
    cur = db.cursor()
    cur.execute("""CREATE TABLE IF NOT EXISTS frl_address (
        permit_number TEXT,
        owner_name TEXT,
        operating_name TEXT,
        street TEXT,
        city TEXT,
        state TEXT,
        zip TEXT,
        county TEXT
    );
    """) 
    assert cur.fetchall() is not None, "Failed to create table"

def save_data(db, data):
    if data is None or len(data) == 0:
        return

    cur = db.cursor()
    cur.executemany("""INSERT INTO frl_address 
        (permit_number, owner_name, operating_name, street, city, state, zip, county)
        VALUES (?,?,?,?,?,?,?,?)
    """, data)
    assert cur.fetchall() is not None, "Failed to create table"

def format_hdr(df):
    data = df.replace("\n","_").replace("\t","_").replace(" ","_")
    return data

def format_cell(df):
    data = str(df or "").replace("\n"," ")
    return data

def convert_xlsx(xlsFile, dbFile="frl_permits.db"):
    csvFile = xlsFile[:-3] + ".csv"
    wb_obj = openpyxl.load_workbook(xlsFile)
    db = sqlite3.connect(dbFile)
    data_setup(db)
    logger.info(f"""Importing from {xlsFile}""")

    # Read the active sheet:
    sheet = wb_obj.active
    hdr = None
    vals = []
    for row in sheet.iter_rows():
        if row[0].row < 9:
            continue
        if hdr is None:
            hdr = [format_hdr(r.value) for r in row]
        else:
            vals += [[format_cell(r.value) for r in row]]
            if row[0].value is None:
                pass
                #break

            logger.debug(f"{vals[-1]}")
    save_data(db, vals)
    db.commit()

def convert_htm(htmFile):
    csvFile = htmFile[:-3] + ".csv"
    d = read_dom(htmlFile)
    t = parse_dom(d)

    outf = open(csvFile, 'wb')
    w = csv.writer(outf, delimiter=',', quotechar='"', encoding='utf-8')
    itm = t[1]
    r = []
    rsc = 0
    rsf = 0
    for row in itm.findAll('tr'):
        for cell in row.findAll('td'):
            c = cell.getText()
            if c == u'&nbsp;':
                c = ''
            rs = int(cell['rowspan'])
            if (not rs == None) and rs > 1:
                rv = c
                rsc = rs
                rsf = 1
                print('extra col is %s %s'%(rs, rv))
            r += [c]

        if rsf == 0 and rsc > 0: 
            # print('injecting extra col for row %d, %s'%(rsc, r[0]))
            if rsc == 1:
                rv = rv + ':'
            r = [rv] + r
            rsc -= 1

        # skip summary rows
        if not r[0].endswith(':'):
            #print(r)
            try:
                w.writerow(r)
            except:
                print("skipping")
                print(r)
        r = []
        rsf = 0

    outf.close()
    
def main(args):
    for g in glob.glob(args[1] + "/*.htm"):
        #convert_htm(g)
        #conert('ttb/frl-puerto-rico-permits.htm', 'ttb/frl-puerto-rico-permits.htm.csv')
        pass

    for g in glob.glob(args[1] + "/*.xlsx"):
        convert_xlsx(g)

if "__main__" == __name__:
    logging.basicConfig(level=logging.INFO)
    main(sys.argv)

