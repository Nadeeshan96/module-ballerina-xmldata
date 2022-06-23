// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

type Details record {
    string name;
    int age;
};

@test:Config {
    groups: ["fromXml"]
}
isolated function testToRecord1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>Supun</name>`;
    xml x3 = x1 + x2;
    Details|error actual = fromXml(x3, Details);
    if (actual is error) {
        test:assertTrue(actual.message().includes("'string' value cannot be converted to 'xmldata:Details'"),
        msg = "testToRecord result incorrect");
    } else {
        test:assertFail(msg = "testToRecord1 result incorrect");
    }
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testToRecord2() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<Details><name>Supun</name><age>5</age></Details>`;
    xml x3 = x1 + x2;
    Details expected = {
        name: "Supun",
        age: 5
    };
    Details actual = check fromXml(x3, Details);
    test:assertEquals(actual, expected, msg = "testToRecord2 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToDefaultRecord1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>Supun</name>`;
    xml x3 = x1 + x2;
    record {string name;} expected = {"name": "Supun"};
    record {string name;} actual = check fromXml(x3);
    test:assertEquals(actual, expected, msg = "testXmlToDefaultRecord1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapJson1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>Supun</name>`;
    xml x3 = x1 + x2;

    map<json> expected = {
        name: "Supun"
    };
    map<json> actual = check fromXml(x3);
    test:assertEquals(actual, expected, msg = "testXmlToMapJson1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapString1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>Supun</name>`;
    xml x3 = x1 + x2;

    map<string> expected = {
        name: "Supun"
    };

    map<string> actual = check fromXml(x3);
    test:assertEquals(actual, expected, msg = "testXmlToMapString1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapBoolean1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>true</name>`;
    xml x3 = x1 + x2;

    map<boolean> expected = {
        name: true
    };

    map<boolean> actual = check fromXml(x3);
    test:assertEquals(actual, expected, msg = "testXmlToMapBoolean1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapInt1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>5</name>`;
    xml x3 = x1 + x2;

    map<int> expected = {
        name: 5
    };

    map<int> actual = check fromXml(x3);
    test:assertEquals(actual, expected, msg = "testXmlToMapInt1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapDecimal1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>0.5</name>`;
    xml x3 = x1 + x2;

    map<decimal> expected = {
        name: 0.5
    };

    map<decimal> actual = check fromXml(x3);
    test:assertEquals(actual, expected, msg = "testXmlToMapDecimal1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapFloat1() returns error? {
    var x1 = xml `<!-- outer comment -->`;
    var x2 = xml `<name>0.5</name>`;
    xml x3 = x1 + x2;

    map<float> expected = {
        name: 0.5
    };

    map<float> actual = check fromXml(x3);
    test:assertEquals(actual, expected, msg = "testXmlToMapFloat1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapXml1() returns error? {
    var x1 = xml `<name>0.5</name>`;

    map<xml> expected = {
        "#content": xml `<name>0.5</name>`
    };

    map<xml> actual = check fromXml(x1);
    test:assertEquals(actual, expected, msg = "testXmlToMapXml1 result incorrect");
}

xml xmlData = xml `<Invoice xmlns="example.com" attr="attr-val" xmlns:ns="ns.com" ns:attr="ns-attr-val">
                        <PurchesedItems>
                            <PLine><ItemCode>223345</ItemCode><Count>10</Count></PLine>
                            <PLine><ItemCode>223300</ItemCode><Count>7</Count></PLine>
                            <PLine><ItemCode discount="22%">200777</ItemCode><Count>7</Count></PLine>
                        </PurchesedItems>
                        <Address xmlns="">
                            <StreetAddress>20, Palm grove, Colombo 3</StreetAddress>
                            <City>Colombo</City>
                            <Zip>00300</Zip>
                            <Country>LK</Country>
                        </Address>
                    </Invoice>`;

@test:Config {
    groups: ["fromXml"]
}
function testToJsonWithComplexXmlElement() returns Error? {
    map<json> j = check fromXml(xmlData);
    map<json> expectedOutput = {
        Invoice: {
            PurchesedItems: {
                PLine: [
                    {ItemCode: "223345", Count: "10"},
                    {ItemCode: "223300", Count: "7"},
                    {
                        ItemCode: {"discount": "22%", "#content": "200777"},
                        Count: "7"
                    }
                ]
            },
            Address: {
                StreetAddress: "20, Palm grove, Colombo 3",
                City: "Colombo",
                Zip: "00300",
                Country: "LK",
                "xmlns": ""
            },
            "xmlns:ns": "ns.com",
            "xmlns": "example.com",
            "attr": "attr-val",
            "ns:attr": "ns-attr-val"
        }
    };
    test:assertEquals(j, expectedOutput, msg = "testToJsonComplexXmlElement result incorrect");
}

type BookStore4 record {
    string storeName;
    int postalCode;
    boolean isOpen;
    Address4 address;
    Codes4 codes;
    @Attribute
    string status;
    @Attribute
    string 'xmlns\:ns0;
};

type Address4 record {
    string street;
    string city;
    string country;
};

type Codes4 record {
    int[] item;
};

@test:Config {
    groups: ["fromXml"]
}
isolated function testRecordToXml4() returns error? {
    xml payload = xml `<bookstore status="online" xmlns:ns0="http://sample.com/test">
                            <storeName>foo</storeName>
                            <postalCode>94</postalCode>
                            <isOpen>true</isOpen>
                            <address>
                                <street>Galle Road</street>
                                <city>Colombo</city>
                                <country>Sri Lanka</country>
                            </address>
                            <codes>
                                <item>4</item>
                                <item>8</item>
                                <item>9</item>
                            </codes>
                        </bookstore>
                        <!-- some comment -->
                        <?doc document="book.doc"?>`;
    BookStore4 expected = {
        storeName: "foo",
        postalCode: 94,
        isOpen: true,
        address: {
            street: "Galle Road",
            city: "Colombo",
            country: "Sri Lanka"
        },
        codes: {
            item: [4, 8, 9]
        },
        'xmlns\:ns0: "http://sample.com/test",
        status: "online"
    };
    BookStore4 actual = check fromXml(payload);
    test:assertEquals(actual, expected, msg = "testToRecordWithNamespaces result incorrect");
}

type BookStore5 record {
    xml storeName;
    int postalCode;
    boolean isOpen;
    xml address;
    xml codes;
    @Attribute
    string status;
    @Attribute
    string 'xmlns\:ns0;
};

type Address5 record {
    string street;
    string city;
    string country;
};

type Codes5 record {
    int[] item;
};

@test:Config {
    groups: ["fromXml"]
}
isolated function testRecordToXml5() returns error? {
    xml payload = xml `<bookstore status="online" xmlns:ns0="http://sample.com/test">
                            <storeName>foo</storeName>
                            <postalCode>94</postalCode>
                            <isOpen>true</isOpen>
                            <address>
                                <street>Galle Road</street>
                                <city>Colombo</city>
                                <country>Sri Lanka</country>
                            </address>
                            <codes>
                                <item>4</item>
                                <item>8</item>
                                <item>9</item>
                            </codes>
                        </bookstore>
                        <!-- some comment -->
                        <?doc document="book.doc"?>`;
    BookStore5 expected = {
        storeName: xml `foo`,
        postalCode: 94,
        isOpen: true,
        address: xml `<street>Galle Road</street><city>Colombo</city><country>Sri Lanka</country>`,
        codes: xml `<item>4</item><item>8</item><item>9</item>`,
        'xmlns\:ns0: "http://sample.com/test",
        status: "online"
    };
    BookStore5 actual = check fromXml(payload);
    test:assertEquals(actual, expected, msg = "testRecordToXml5 result incorrect");
}

xml xmValue = xml `<Invoice xmlns="example.com" attr="attr-val" xmlns:ns="ns.com" ns:attr="ns-attr-val">
                <PurchesedItems>
                    <PLine><ItemCode>223345</ItemCode><Count>10</Count></PLine>
                    <PLine><ItemCode>223300</ItemCode><Count>7</Count></PLine>
                    <PLine><ItemCode discount="22%">200777</ItemCode><Count>7</Count></PLine>
                </PurchesedItems>
                <Address xmlns="">
                    <StreetAddress>20, Palm grove, Colombo 3</StreetAddress>
                    <City>Colombo</City>
                    <Zip>300</Zip>
                    <Country>LK</Country>
                </Address>
              </Invoice>`;

type Invoice1 record {
    PurchesedItems1 PurchesedItems;
    Address10 Address;
    string 'xmlns?;
    string 'xmlns\:ns?;
    string attr?;
    string ns\:attr?;
};

type PurchesedItems1 record {
    Purchase1[] PLine;
};

type Purchase1 record {
    string|ItemCode1 ItemCode;
    int Count;
};

type ItemCode1 record {
    string discount;
    string \#content;
};

type Address10 record {
    string StreetAddress;
    string City;
    int Zip;
    string Country;
    string 'xmlns?;
};

@test:Config {
    groups: ["toRecord"]
}
function testComplexXmlElementToRecord() returns error? {
    Invoice1 expected = {
        PurchesedItems: {
            PLine: [
                {ItemCode: "223345", Count: 10},
                {ItemCode: "223300", Count: 7},
                {
                    ItemCode: {discount: "22%", \#content: "200777"},
                    Count: 7
                }
            ]
        },
        Address: {
            StreetAddress: "20, Palm grove, Colombo 3",
            City: "Colombo",
            Zip: 300,
            Country: "LK",
            'xmlns: ""
        },
        'xmlns: "example.com",
        'xmlns\:ns: "ns.com",
        attr: "attr-val",
        ns\:attr: "ns-attr-val"
    };
    Invoice1 actual = check fromXml(xmValue);
    test:assertEquals(actual, expected, msg = "testRecordToComplexXmlElement result incorrect");
}

@test:Config {
    groups: ["toRecord"]
}
function testComplexXmlElementToMapJson() returns error? {
    map<json> expected = {
        Invoice: {
            PurchesedItems: {
                PLine: [
                    {ItemCode: "223345", Count: "10"},
                    {ItemCode: "223300", Count: "7"},
                    {
                        ItemCode: {discount: "22%", \#content: "200777"},
                        Count: "7"
                    }
                ]
            },
            Address: {
                StreetAddress: "20, Palm grove, Colombo 3",
                City: "Colombo",
                Zip: "300",
                Country: "LK",
                'xmlns: ""
            },
            'xmlns: "example.com",
            'xmlns\:ns: "ns.com",
            attr: "attr-val",
            ns\:attr: "ns-attr-val"
        }
    };
    map<json> actual = check fromXml(xmValue);
    test:assertEquals(actual, expected, msg = "testComplexXmlElementToMapJson result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapString11() returns error? {
    var x2 = xml `<names><name>Supun</name><name>Supun</name></names>`;

    map<string[]>|error actual = fromXml(x2);
    if (actual is error) {
        test:assertEquals(actual.message(),
                        "Failed to convert the xml:<name>Supun</name><name>Supun</name> to string[] type.",
                        msg = "testToRecord result incorrect");
    } else {
        test:assertFail(msg = "testToRecord1 result incorrect");
    }
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapIntArray() returns error? {
    var x = xml `<age>5</age>`;

    map<int[]> expected = {
        age: [5]
    };

    map<int[]> actual = check fromXml(x);
    test:assertEquals(actual, expected, msg = "testXmlToMapIntArray result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapFloatArray() returns error? {
    var x = xml `<age>5</age>`;

    map<float[]> expected = {
        age: [5]
    };

    map<float[]> actual = check fromXml(x);
    test:assertEquals(actual, expected, msg = "testXmlToMapFloatArray result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapDecimalArray() returns error? {
    var x = xml `<age>5</age>`;

    map<decimal[]> expected = {
        age: [5]
    };

    map<decimal[]> actual = check fromXml(x);
    test:assertEquals(actual, expected, msg = "testXmlToMapFloatArray result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapBooleanArray() returns error? {
    var x = xml `<value>true</value>`;

    map<boolean[]> expected = {
        value: [true]
    };

    map<boolean[]> actual = check fromXml(x);
    test:assertEquals(actual, expected, msg = "testXmlToMapBooleanArray result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapTable1() returns error? {
    xml x1 = xml `<keys><key>value</key></keys>`;
    map<table<map<string>>> expected = {"keys": table [{"key": "value"}]};
    map<table<map<string>>> actual = check fromXml(x1);
    test:assertEquals(actual, expected, msg = "testXmlToMapJson1 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapTable2() returns error? {
    xml x1 = xml `<keys><key>1</key></keys>`;
    map<table<map<int>>> expected = {"keys": table [{key: 1}]};
    map<table<map<int>>> actual = check fromXml(x1);
    test:assertEquals(actual, expected, msg = "testXmlToMapTable2 result incorrect");
}

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapTable3() returns error? {
    xml x1 = xml `<keys><key1>1</key1><key2>2</key2></keys>`;
    map<table<map<int>>> expected = {keys: table [{key1: 1, key2: 2}]};
    map<table<map<int>>> actual = check fromXml(x1);
    test:assertEquals(actual, expected, msg = "testXmlToMapTable3 result incorrect");
}

type Table record {
    int key1;
    int key2;
};

@test:Config {
    groups: ["fromXml"]
}
isolated function testXmlToMapTable4() returns error? {
    xml x1 = xml `<keys><key1>1</key1><key2>2</key2></keys>`;
    map<table<Table>> expected = {keys: table [{key1: 1, key2: 2}]};
    map<table<Table>> actual = check fromXml(x1);
    test:assertEquals(actual, expected, msg = "testXmlToMapTable4 result incorrect");
}
