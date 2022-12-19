PGDMP     #                    z            subscription     14.6 (Ubuntu 14.6-1.pgdg22.10+1)     15.1 (Ubuntu 15.1-1.pgdg22.10+1) +    l           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            m           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            n           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            o           1262    16472    subscription    DATABASE     x   CREATE DATABASE subscription WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru_RU.UTF-8';
    DROP DATABASE subscription;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            p           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    4            �            1259    16568 	   t_address    TABLE     �  CREATE TABLE public.t_address (
    id integer NOT NULL,
    post_code character varying(6),
    region character varying(30) NOT NULL,
    city character varying(30) NOT NULL,
    street character varying(50) NOT NULL,
    house integer,
    apartment integer,
    CONSTRAINT t_address_apartment_check CHECK (((apartment > 0) OR NULL::boolean)),
    CONSTRAINT t_address_house_check CHECK ((house > 0))
);
    DROP TABLE public.t_address;
       public         heap    postgres    false    4            �            1259    16567    t_address_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.t_address_id_seq;
       public          postgres    false    210    4            q           0    0    t_address_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.t_address_id_seq OWNED BY public.t_address.id;
          public          postgres    false    209            �            1259    24872    t_publishing    TABLE     �   CREATE TABLE public.t_publishing (
    id character varying(6) NOT NULL,
    idpubhouse character varying(7),
    pubname character varying(50) NOT NULL,
    description text
);
     DROP TABLE public.t_publishing;
       public         heap    postgres    false    4            �            1259    24898    t_subs    TABLE     �   CREATE TABLE public.t_subs (
    idpod integer NOT NULL,
    datestart date NOT NULL,
    idpub character varying(6) NOT NULL,
    idperiod integer NOT NULL
);
    DROP TABLE public.t_subs;
       public         heap    postgres    false    4            �            1259    24995    t_cpod_publishings    VIEW     ?  CREATE VIEW public.t_cpod_publishings AS
 SELECT t_publishing.pubname AS "Издание",
    count(t_subs.idpod) AS "Количество_подписчиков"
   FROM (public.t_subs
     JOIN public.t_publishing ON (((t_subs.idpub)::text = (t_publishing.id)::text)))
  GROUP BY t_subs.idpub, t_publishing.pubname;
 %   DROP VIEW public.t_cpod_publishings;
       public          postgres    false    216    214    216    214    4            �            1259    16577    t_pod    TABLE     s   CREATE TABLE public.t_pod (
    id integer NOT NULL,
    fio character varying(85) NOT NULL,
    idaddr integer
);
    DROP TABLE public.t_pod;
       public         heap    postgres    false    4            �            1259    25004    t_novogolvill    VIEW     �  CREATE VIEW public.t_novogolvill AS
 SELECT t_address.street AS "Улица_города_Новоголвилль",
    t_pod.fio AS "ФИО"
   FROM ((public.t_subs
     JOIN public.t_pod ON ((t_pod.id = t_subs.idpod)))
     JOIN public.t_address ON ((t_address.id = t_pod.idaddr)))
  WHERE ((t_address.city)::text = 'Новоголвилль'::text)
  GROUP BY t_address.street, t_address.house, t_pod.fio
  ORDER BY t_address.house;
     DROP VIEW public.t_novogolvill;
       public          postgres    false    212    212    212    216    210    210    210    210    4            �            1259    24887    t_period    TABLE     �   CREATE TABLE public.t_period (
    idpub character varying(6) NOT NULL,
    period integer NOT NULL,
    periodname character varying(20) NOT NULL,
    price money,
    CONSTRAINT period CHECK ((period > 0))
);
    DROP TABLE public.t_period;
       public         heap    postgres    false    4            �            1259    16576    t_pod_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_pod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.t_pod_id_seq;
       public          postgres    false    212    4            r           0    0    t_pod_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.t_pod_id_seq OWNED BY public.t_pod.id;
          public          postgres    false    211            �            1259    24999    t_pods_2017_07_21    VIEW     %  CREATE VIEW public.t_pods_2017_07_21 AS
 SELECT t_pod.fio AS "ФИО",
    ((((((((('Регион '::text || (t_address.region)::text) || ', город '::text) || (t_address.city)::text) || ', улица '::text) || (t_address.street)::text) || ', дом '::text) || t_address.house) || ', квартира '::text) || t_address.apartment) AS "Адрес",
    t_publishing.pubname AS "Издание"
   FROM (((public.t_subs
     JOIN public.t_pod ON ((t_pod.id = t_subs.idpod)))
     JOIN public.t_publishing ON (((t_publishing.id)::text = (t_subs.idpub)::text)))
     JOIN public.t_address ON ((t_address.id = t_pod.idaddr)))
  WHERE (('2017-07-21'::date >= t_subs.datestart) AND ('2017-07-21 00:00:00'::timestamp without time zone <= (t_subs.datestart + make_interval(months => t_subs.idperiod))));
 $   DROP VIEW public.t_pods_2017_07_21;
       public          postgres    false    216    216    216    216    214    214    212    212    212    210    210    210    210    210    210    4            �            1259    16617 
   t_pubhouse    TABLE     }  CREATE TABLE public.t_pubhouse (
    id character varying(7) NOT NULL,
    name character varying(50) NOT NULL,
    idaddr integer,
    phone character varying(15),
    CONSTRAINT t_pubhouse_id_check CHECK (((id)::text ~ similar_to_escape('\d{2,7}'::text))),
    CONSTRAINT t_pubhouse_phone_check CHECK (((phone)::text ~ similar_to_escape('\(\d{4}\) \d{2}-\d{2}-\d{2}'::text)))
);
    DROP TABLE public.t_pubhouse;
       public         heap    postgres    false    4            �            1259    24991    t_subs_pub_donkey    VIEW     }  CREATE VIEW public.t_subs_pub_donkey AS
 SELECT t_pod.fio AS "Подписчики_на_Мин_говор_ослы"
   FROM ((public.t_subs
     JOIN public.t_publishing ON (((t_subs.idpub)::text = (t_publishing.id)::text)))
     JOIN public.t_pod ON ((t_subs.idpod = t_pod.id)))
  WHERE ((t_publishing.pubname)::text = 'Миниатюрные говорящие ослы'::text);
 $   DROP VIEW public.t_subs_pub_donkey;
       public          postgres    false    212    214    212    214    216    216    4            �           2604    16571    t_address id    DEFAULT     l   ALTER TABLE ONLY public.t_address ALTER COLUMN id SET DEFAULT nextval('public.t_address_id_seq'::regclass);
 ;   ALTER TABLE public.t_address ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    210    210            �           2604    16580    t_pod id    DEFAULT     d   ALTER TABLE ONLY public.t_pod ALTER COLUMN id SET DEFAULT nextval('public.t_pod_id_seq'::regclass);
 7   ALTER TABLE public.t_pod ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211    212            c          0    16568 	   t_address 
   TABLE DATA           Z   COPY public.t_address (id, post_code, region, city, street, house, apartment) FROM stdin;
    public          postgres    false    210   O9       h          0    24887    t_period 
   TABLE DATA           D   COPY public.t_period (idpub, period, periodname, price) FROM stdin;
    public          postgres    false    215   �:       e          0    16577    t_pod 
   TABLE DATA           0   COPY public.t_pod (id, fio, idaddr) FROM stdin;
    public          postgres    false    212   �;       f          0    16617 
   t_pubhouse 
   TABLE DATA           =   COPY public.t_pubhouse (id, name, idaddr, phone) FROM stdin;
    public          postgres    false    213   �<       g          0    24872    t_publishing 
   TABLE DATA           L   COPY public.t_publishing (id, idpubhouse, pubname, description) FROM stdin;
    public          postgres    false    214   �=       i          0    24898    t_subs 
   TABLE DATA           C   COPY public.t_subs (idpod, datestart, idpub, idperiod) FROM stdin;
    public          postgres    false    216   �K       s           0    0    t_address_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.t_address_id_seq', 4, true);
          public          postgres    false    209            t           0    0    t_pod_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.t_pod_id_seq', 2, true);
          public          postgres    false    211            �           2606    24944    t_publishing id    CHECK CONSTRAINT     �   ALTER TABLE public.t_publishing
    ADD CONSTRAINT id CHECK ((((id)::text ~ similar_to_escape('\d{6}'::text)) AND (NOT ((id)::text = '000000'::text)))) NOT VALID;
 4   ALTER TABLE public.t_publishing DROP CONSTRAINT id;
       public          postgres    false    214    214            �           2606    16575    t_address t_address_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.t_address
    ADD CONSTRAINT t_address_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.t_address DROP CONSTRAINT t_address_pkey;
       public            postgres    false    210            �           2606    24892    t_period t_period_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.t_period
    ADD CONSTRAINT t_period_pkey PRIMARY KEY (idpub, period);
 @   ALTER TABLE ONLY public.t_period DROP CONSTRAINT t_period_pkey;
       public            postgres    false    215    215            �           2606    16582    t_pod t_pod_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.t_pod
    ADD CONSTRAINT t_pod_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.t_pod DROP CONSTRAINT t_pod_pkey;
       public            postgres    false    212            �           2606    24920    t_pubhouse t_pubhouse_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.t_pubhouse
    ADD CONSTRAINT t_pubhouse_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.t_pubhouse DROP CONSTRAINT t_pubhouse_pkey;
       public            postgres    false    213            �           2606    24886    t_publishing t_publishing_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.t_publishing
    ADD CONSTRAINT t_publishing_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.t_publishing DROP CONSTRAINT t_publishing_pkey;
       public            postgres    false    214            �           2606    24902    t_subs t_subs_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.t_subs
    ADD CONSTRAINT t_subs_pkey PRIMARY KEY (idpod, idpub, idperiod);
 <   ALTER TABLE ONLY public.t_subs DROP CONSTRAINT t_subs_pkey;
       public            postgres    false    216    216    216            �           2606    24903    t_subs idpod    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_subs
    ADD CONSTRAINT idpod FOREIGN KEY (idpod) REFERENCES public.t_pod(id) ON UPDATE CASCADE ON DELETE CASCADE;
 6   ALTER TABLE ONLY public.t_subs DROP CONSTRAINT idpod;
       public          postgres    false    216    3268    212            �           2606    24893    t_period idpub    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_period
    ADD CONSTRAINT idpub FOREIGN KEY (idpub) REFERENCES public.t_publishing(id) ON UPDATE CASCADE ON DELETE CASCADE;
 8   ALTER TABLE ONLY public.t_period DROP CONSTRAINT idpub;
       public          postgres    false    214    215    3272            �           2606    24922    t_publishing idpubhouse    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_publishing
    ADD CONSTRAINT idpubhouse FOREIGN KEY (idpubhouse) REFERENCES public.t_pubhouse(id) ON UPDATE CASCADE ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.t_publishing DROP CONSTRAINT idpubhouse;
       public          postgres    false    213    214    3270            �           2606    24913    t_pubhouse inaddr    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_pubhouse
    ADD CONSTRAINT inaddr FOREIGN KEY (idaddr) REFERENCES public.t_address(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 ;   ALTER TABLE ONLY public.t_pubhouse DROP CONSTRAINT inaddr;
       public          postgres    false    213    3266    210            �           2606    24945    t_subs period    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_subs
    ADD CONSTRAINT period FOREIGN KEY (idperiod, idpub) REFERENCES public.t_period(period, idpub) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 7   ALTER TABLE ONLY public.t_subs DROP CONSTRAINT period;
       public          postgres    false    215    3274    216    216    215            �           2606    16583    t_pod t_pod_idaddr_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.t_pod
    ADD CONSTRAINT t_pod_idaddr_fkey FOREIGN KEY (idaddr) REFERENCES public.t_address(id);
 A   ALTER TABLE ONLY public.t_pod DROP CONSTRAINT t_pod_idaddr_fkey;
       public          postgres    false    210    212    3266            c   t  x��S[N�0�^��'@v��]8L�Z��� �ϐ�&$gؽc.P�+������1��>������ne�%��q~��^f���S�+YɒM.Q	e6թ%~�0ȥl&�t�rI� Y����4~#�#�r���dw��p'+�)�6W)�ȍ'�������dP����}��@!�	h�0�U v�F5����l2�+GF;o3�B/͗A\�zj����P���������cC5��ʏ����hC�9�������:$��qK~����r�rK�3����*���!&�dsJ2eL�Ń�3�"��|Rd�7��Ը�N6i��`p�;����w7��z��+L *g(�#=Y<U���R��rA      h   �   x�e�An�0E��)z�(�H�]z`�EQ�ɮj�,�.i�B���\!'�G��Zɖ,���?�!�R�D�b;��Z��UV�-�E�[9�p+�(u��DR��X�_�-繷g�~A��Kb����6��h�Έ#B�׉��rSن�t�)��4�!?��o]l����K��¼W^}rw���Ň�Q���'��7Χ����o ���@��[a1=��(����/      e     x�]�MN�@���S�	�-��p���ꢕ¯���eH)M����F��@�X̌���Ϟ��F���Յ�<ސ�4�{��B��(Q��K$qxf�є���FS�n�x<�R���k����J�n(#��Љ��d�G֖�sGӄ��.{�H��SG�qL�X��4QS�?���9<��ŉ�3\�'��a�kx	e�tc9wx[�14�$��6d��]��Hf"�VϿ��O.O��ly۳�֚T�y�m��e�?Oe�����0I"W'"��C �      f   �   x�e�=N1Fk�.�Š��g��p�M�AA�D�h� ��@��3|s#�J�d����fBf�7y�'~pqX��Yv��*���\
�=�lyH��g��[�_�*�;Ǖj�\l^��G�;�Oj{��b���3q��2��C�p��a�	�ze��^n|2xW�E�W,�_JR�{�L9����W`R�#������ok�si�ld��Q�Y�����̝L�R������Pq      g   �  x��ZKr�\��h�!I����\�/��}  ?B�$����H{�pDD�M|<A�<'qefU pF
�lt��W���U�w����:|����V�M����:/�e���ÇjX���rY]l�o��aYT�������L�Y�&�~�ɇYR~(�����0)?�2y9�G�$-���P}]]U�rQ]٭vc^N��Į����;��*)�va�5��,ps�{EZN�`ۏ�q/�ufl�T���i5�e�k9��v��<J�3��	~Ȩ�fh�ÊEܟ��}�el��9�h�%�a�GI9��R�iu��&k>2�a�%��;��$�w��+��;��s8�ǝWg�Ҝ��.̖2��ᣱ��}ت؋�w�>�_�ռ�싇�Η_}�U���mG���H�7�����Ç_�� .���}B����/ x�ݓU'�j�w���� �B7�I��52��ǧv喑����4o.�?�y� ��K��zc����-�/3�ckV�diu�T��K2X�W��ٖ#.
�l
�����Y5��&z��a{M=�s�Khf��.�6�P`��jم `��.�*��N�ٿ��y�� ��k�ߞ�q4o����g��v��������?;�*0[�l�,�sSY�@�����5�wD�s�5ܭl��1����`�$��S��IN(Y�����\yǍfL���{����@&�'�l��x. 5:� dJ Ω0��dpɨ�{b�	�����2��F=��.y�W9��R���9P��Pǻ2�g���|��Ijf^��S�?% R�q 	��A%:�̻�Em�_�{2;�p6B�z?"4�F@��Ո��e0��&+ޝV�J�Bk���FK���%�'k�k6��s�Eaf"L����K���v�vS]�l�DY<�:|��������#���縟m�+>sZ�[��[�����Pl�'�$�D�3��k.1��"�!*�C� ��-��}$,[��	Ǟ�1�W���,S�[�\ ��%�Y�S���D� �+e34�ĶI�-����"E���"=��ñ���
AɫZ���a��9�#�+$����:��-4cX��6U�u�*��	 *�
�:j}xhj;�Ya�����Ɯ��ڬ̊P��g�b+����q!����ɽ�����C�G�w��s�L�3/��1Bq��B�����c`�@�N���!̝�"�|&=���̵��NS�����rHq��=�0d�P�#�i�5)�J!��N��raE��>�N�&͆\�kB[���4�')C�ZH	�D.X�
n�yj���AX��)zf9(����r���چ�A�N�yM�,��i��u��6�'�w釂�����omL)�N��o�&�h(K/�	�������Y[:%b�%"A����_h�IH.z��1uUe��ؖ৳�����8��Z��h/�k��� ��c���-X����x��98_�FwB5��Du���4M(�'P���-[�T�r�ބR"��<[��QI�)�u�.z�l�Zy��Y?�F]���)%���[f����a*mNX��s��m��g�A!A35T�\�U���[o����wP���\�A��(JT+���D=M�MM�t���,��"��,K랉B,MG������nHp���N1-��}� b�iڜVl�P׻%�>��
�/E�9e�f����aC������خ	��-��"Kk]��ۤ�����6cڛ��Ց)� �d�͕�F[�/��7�(���)X��M�@��6ɪ�5�=|���C"��<�x����ם#l����8��6I����Cz�_d��̢V�q�؟���>OVC�z�\��^�[*B�S7��z���O-�0��%7�	�Y^;�Ϯ��ظ�b���p��9��TD��r�!�AH�es��q���,*z�'c�����VE��Y��v��u'ƒJx�% �<ѫ'-,��\Y2�ᕱg��C' <���ٴ4Y9�6^��Q%(�Ӵ=�Z[���5��{Q���X5H�s�չ[��px��3�=5c����7�� 9��p�i�A�aV3�����J8i��0d=P-��c/�J����͌bZ�d ���|GR:�;���d��#�V짥�Q�oq�5�;���4�Fag1�;����ݶq���n'%w`Z�W�	sX�|㘂��d�$�ɽ:��vm>9y�a�[�(S�?ǟ�L����i�i5K35��q���۠E=o��E��zJ��B)����x�B��I�el�C-o�m��YK���Ω�����[C�����r['�1����{L}�Y7~Q��N)'��a�ƌ�lEk�)I����R{bxZ����,����u+�_</��A����3�H7c���Fu���fg8���#6��3�Zb'����;�{���/b���'��_���\�cТ��ϛaÒs̴C���]�y��'���=tͲ˩!4e��jr��D����TY���7�-l���.VҤ���0dԔm$`Ff��x����[���3Ɔ�Y�����n$uk0�z6,X�.��z��C����i�h���O�}��~��G��^
7�
�(�4��IƜ��BCe�Oڞs��]��Oz`�*�E��j�f�b����Y�oy���Nǚ<�'t	Yӑqb�x�sw��y�U�zL��lXg`��|:o*��:���:��fקSQ���ُ���z
��E>v�o��V��+�\����
��� ��z۱�*"4n��zj��K�h�N����v<e�y�U1#N��1�^�-jz�/��f�BZ%��0��9��A$��O��co�2�4K	8�~��M������K)u&R����ʴ��o'm��E��U�^'G�A�ђ�B^�~�[��yOR`mδ�e��\�|b�<P��[�+��NOIv}|n��Z)iܩ1���l�r��z���ӕ����=-���i��l�2�&��T�@?�[��(+�����7�D(N�l3�*�Ռ��Y��������bB!��q�r��2;�!�0��u���A����Gp	�l�)�����������'֍Go,����7d�y�f~F�ű��'I�e����?-D���~�_$F�*}1����x��X��vuh�0��3�_K�F�����Ձ��Ӯk9����u��������;y����0yBleQ�����)1��?���_���q`��A#/:��+�P�(��\�L�ų�����:��9�Xm�����F_%I7�$jjXR��QF��Q�Ν0�8>i��4��O�c�K�xW�K�%'>�1z����\�U�F}=���u��T*sM�Q[�!����	Vs�jo�$�:t�݂���3N��lkw��り����4��A]��M sot���1R��FUwx�� ����w�o��&���n��P9W�1M>��rV�A��J5��'���x�Ӽά<Ϊ���84��J&3RB��.��$~�g���������K�R�      i   �   x�E��!�w�%'�z����� �Y�@!l*L9�fNi�B��:�Z���
W�*S�ʺ&K/��C9>��6e �b\c�ň.���k�ż�iQ�բ#�Q�U����^����qG����;bl�>u�,�����J)/�5     