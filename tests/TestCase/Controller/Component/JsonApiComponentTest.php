<?php
/**
 * BEdita, API-first content management framework
 * Copyright 2016 ChannelWeb Srl, Chialab Srl
 *
 * This file is part of BEdita: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * See LICENSE.LGPL or <http://gnu.org/licenses/lgpl-3.0.html> for more details.
 */

namespace BEdita\API\Test\TestCase\Controller\Component;

use BEdita\API\Controller\Component\JsonApiComponent;
use Cake\Controller\ComponentRegistry;
use Cake\Controller\Controller;
use Cake\Network\Request;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\TestSuite\TestCase;

/**
 * @coversDefaultClass \BEdita\API\Controller\Component\JsonApiComponent
 */
class JsonApiComponentTest extends TestCase
{
    /**
     * {@inheritDoc}
     */
    public $autoFixtures = false;

    /**
     * Fixtures.
     *
     * @var array
     */
    public $fixtures = [
        'plugin.BEdita/Core.users',
    ];

    /**
     * {@inheritDoc}
     */
    public function setUp()
    {
        parent::setUp();

        Router::fullBaseUrl('http://example.org');
    }

    /**
     * Data provider for `testInitialize` test case.
     *
     * @return array
     */
    public function initializeProvider()
    {
        return [
            'default' => [
                'application/vnd.api+json',
                [],
            ],
            'json' => [
                'application/json',
                [
                    'contentType' => 'application/json',
                ],
            ],
        ];
    }

    /**
     * Test component initialization.
     *
     * @param string $expectedMimeType Expected response MIME Type.
     * @param array $config Component configuration.
     * @return void
     *
     * @dataProvider initializeProvider
     * @covers ::initialize()
     */
    public function testInitialize($expectedMimeType, array $config)
    {
        $component = new JsonApiComponent(new ComponentRegistry(new Controller()), $config);

        $this->assertEquals($expectedMimeType, $component->response->getMimeType('jsonApi'));
        $this->assertArrayHasKey('jsonApi', $component->RequestHandler->config('inputTypeMap'));
        $this->assertArrayHasKey('jsonApi', $component->RequestHandler->config('viewClassMap'));
    }

    /**
     * Test component `getLinks()` method.
     *
     * @return void
     *
     * @covers ::getLinks()
     */
    public function testLinks()
    {
        $expected = [
            'self' => 'http://example.org/users',
            'home' => 'http://example.org/home',
        ];

        $request = new Request([
            'params' => [
                'controller' => 'Users',
                'action' => 'index',
                '_method' => 'GET',
            ],
            'base' => '/',
            'url' => 'users',
        ]);
        $controller = new Controller($request);
        $component = new JsonApiComponent(new ComponentRegistry($controller), []);

        $this->assertEquals($expected, $component->getLinks());
    }

    /**
     * Data provider for `testPagination` test case.
     *
     * @return array
     */
    public function paginationProvider()
    {
        return [
            'default' => [
                [
                    'self' => 'http://example.org/users',
                    'first' => 'http://example.org/users',
                    'last' => 'http://example.org/users',
                    'prev' => null,
                    'next' => null,
                    'home' => 'http://example.org/home',
                ],
                [
                    'pagination' => [
                        'count' => 2,
                        'page' => 1,
                        'page_count' => 1,
                        'page_items' => 2,
                        'page_size' => 20,
                    ],
                ],
                [],
            ],
            'limit' => [
                [
                    'self' => 'http://example.org/users?limit=1',
                    'first' => 'http://example.org/users?limit=1',
                    'last' => 'http://example.org/users?limit=1&page=2',
                    'prev' => null,
                    'next' => 'http://example.org/users?limit=1&page=2',
                    'home' => 'http://example.org/home',
                ],
                [
                    'pagination' => [
                        'count' => 2,
                        'page' => 1,
                        'page_count' => 2,
                        'page_items' => 1,
                        'page_size' => 1,
                    ],
                ],
                [
                    'limit' => 1,
                ],
            ],
            'page' => [
                [
                    'self' => 'http://example.org/users?page=2&limit=1',
                    'first' => 'http://example.org/users?limit=1',
                    'last' => 'http://example.org/users?page=2&limit=1',
                    'prev' => 'http://example.org/users?limit=1',
                    'next' => null,
                    'home' => 'http://example.org/home',
                ],
                [
                    'pagination' => [
                        'count' => 2,
                        'page' => 2,
                        'page_count' => 2,
                        'page_items' => 1,
                        'page_size' => 1,
                    ],
                ],
                [
                    'page' => 2,
                    'limit' => 1,
                ],
            ],
        ];
    }

    /**
     * Test component `getLinks()` and `getMeta()` methods with pagination.
     *
     * @param array $expectedLinks Expected links array.
     * @param array $expectedMeta Expected meta array.
     * @param array $query Request query params.
     * @return void
     *
     * @dataProvider paginationProvider
     * @covers ::getLinks()
     * @covers ::getMeta()
     */
    public function testPagination(array $expectedLinks, array $expectedMeta, array $query)
    {
        $this->loadFixtures('Users');

        $request = new Request([
            'params' => [
                'controller' => 'Users',
                'action' => 'index',
                '_method' => 'GET',
            ],
            'base' => '/',
            'url' => 'users',
            'query' => $query,
        ]);
        $controller = new Controller($request);
        $controller->paginate(TableRegistry::get('BEdita/Core.Users'));
        $component = new JsonApiComponent(new ComponentRegistry($controller), []);

        $this->assertEquals($expectedLinks, $component->getLinks());
        $this->assertEquals($expectedMeta, $component->getMeta());
    }

    /**
     * Test `error()` method.
     *
     * @return void
     *
     * @covers ::error()
     */
    public function testError()
    {
        $expected = [
            'status' => '500',
            'title' => 'Example error',
            'description' => 'Example description',
            'meta' => [
                'key' => 'Example metadata',
            ],
        ];

        $controller = new Controller();
        $component = new JsonApiComponent(new ComponentRegistry($controller), []);

        $component->error(500, 'Example error', 'Example description', ['key' => 'Example metadata']);

        $this->assertEquals($expected, $controller->viewVars['_error']);
    }
}
